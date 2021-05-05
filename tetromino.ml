(*
                         CS 51 Final Project
                            OCaml Tetris

                             Tetrominoes
 *)

open Config ;;
open Model ;;
module V = Visualization ;;

(* new square initx inity -- Creates a square at the given initial position. *)
class square (initx : int) (inity : int) =
  object
    val mutable posx : int = initx
    val mutable posy : int = inity

    (* get_pos () -- Returns a tuple of the positions. *)
    method get_pos : int * int = posx, posy

    (* set_pos (x, y) -- Updates the position of the square *)
    method set_pos (x, y : int * int) : unit =
      posx <- x;
      posy <- y

    (* move (cx, cy) a -- Returns the position of the moved square.
                          Center is passed to calculate rotation *)
    method move ((cx, cy) : int * int) (a : action) : int * int =
      match a with
      | Left -> (posx - 1), posy
      | Down -> posx, (posy - 1)
      | Right -> (posx + 1), posy
      | CW -> (cx + posy - cy), (cy - posx + cx) (* derived from 90 degree rotation matrix *)
      | CCW -> (cx - posy + cy), (cy + posx - cx) (* similarly to above *)
      | NoAction -> (0, 0)
      | Drop -> failwith "Squares shouldn't drop"

    (* add_to_model m -- Adds the square to the model by setting the
                         corresponding int in the model to that color *)
    method add_to_model (m : model) (c : int) : unit =
      m.(posy).(posx) <- c
  end

(* new tetromino others color -- Creates the tetromino defined by the squares in
                                 `others`. These are the squares "other" than
                                 the center square. *)
class tetromino (others : (int * int) list) (color : int) =
  object (this)
    val center = new square ((cBOARD_X - 1)/2) (cBOARD_Y + 1)
    val mutable square_list = []

    initializer
      let (cx, cy) = center#get_pos in
      square_list <- center ::
        List.map (fun (dx, dy) -> new square (cx + dx) (cy + dy)) others

    (* get_pos () -- Returns a list of all the squares' positions in the piece *)
    method get_pos : (int * int) list =
      List.map (fun sq -> sq#get_pos) square_list

    (* move m a -- Attempts to move the piece returning true on success, false on
                   failure or NoAction. First gets the position of all the moved squares (shifted).
                   Then checks those squares against the model, if all is clear, it sets the
                   position of the squares to the moved ones. *)
    method move (m : model) (a : action) : bool =
      if a = NoAction then false
      else if a = Drop then (this#move m Down) && (this#move m Drop)
      else
        let shifted = List.map (fun sq -> sq#move center#get_pos a) square_list in
        if List.fold_right (fun pos -> (||) (sq_full pos m)) shifted false then false
        else
          (List.iter2 (fun sq pos -> sq#set_pos pos) square_list shifted; true)

    (* add_to_model m -- Adds the piece to the model by using each square's `add_to_model`
                         function. *)
    method add_to_model (m : model) : unit =
      List.iter (fun sq -> sq#add_to_model m color) square_list

    (* draw -- Gets the position of each square in a list and then fills each. *)
    method draw =
      List.iter (fun pos -> V.fill_square pos color) this#get_pos

    method draw_queue =
      let quepos = List.map (fun (dx, dy) -> (cBOARD_X + dx + 2, cBOARD_Y + dy))
                            ((0, 0) :: others) in
      List.iter (fun pos -> V.fill_square pos color) quepos
  end

class ipiece =
  object
    inherit tetromino [(-1,0);(1,0);(2,0)] iColor
  end

class jpiece =
  object
    inherit tetromino [(1,0);(-1,0);(-1,1)] jColor
  end

class lpiece =
  object
    inherit tetromino [(-1,0);(1,0);(1,1)] lColor
  end

class opiece =
  object
    inherit tetromino [(0,1);(1,0);(1,1)] oColor
  end

class spiece =
  object
    inherit tetromino [(-1,0);(0,1);(1,1)] sColor
  end

class tpiece =
  object
    inherit tetromino [(-1,0);(0,1);(1,0)] tColor
  end

class zpiece =
  object
    inherit tetromino [(1,0);(0,1);(-1,1)] zColor
  end