(*
                         CS 51 Final Project
                            OCaml Tetris

                             Tetriminos
 *)

open Config ;;
open Model ;;

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
                         corresponding boolean in the model to true *)
    method add_to_model (m : model) : unit =
      m.(posy).(posx) <- true
  end

class tetrimino (p : piece)=
  object (this)
    val center = new square ((cBOARD_X - 1)/2) (cBOARD_Y + 1)
    val mutable square_list = []

    initializer
      square_list <- center ::
      (let (cx, cy) = center#get_pos in 
        match p with  (* lines are a bit long, but what they do is clear
                         and this format is preferable to writing 14 more lines *)
       | I -> [new square (cx - 1) cy; new square (cx + 1) cy; new square (cx + 2) cy]
       | J -> [new square (cx + 1) cy; new square (cx - 1) cy; new square (cx - 1) (cy + 1)]
       | L -> [new square (cx - 1) cy; new square (cx + 1) cy; new square (cx + 1) (cy + 1)]
       | O -> [new square cx (cy + 1); new square (cx + 1) cy; new square (cx + 1) (cy + 1)]
       | S -> [new square (cx - 1) cy; new square cx (cy + 1); new square (cx + 1) (cy + 1)]
       | T -> [new square (cx - 1) cy; new square cx (cy + 1); new square (cx + 1) cy]
       | Z -> [new square (cx + 1) cy; new square cx (cy + 1); new square (cx - 1) (cy + 1)])

    (* get_pos () -- Returns a list of all the squares in the piece *)
    method get_pos : (int * int) list =
      List.map (fun sq -> sq#get_pos) square_list

    (* move m a -- Attempts to move the piece returning true on success, false on
                   failure or NoAction. First gets the position of all the moved squares.
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
      List.iter (fun sq -> sq#add_to_model m) square_list
  end