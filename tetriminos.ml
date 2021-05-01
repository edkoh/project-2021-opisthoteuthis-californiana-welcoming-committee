(*
                         CS 51 Final Project
                            OCaml Tetris

                             Tetriminos
 *)

open Config ;;
module O = Orientation ;;

class square (initx : int) (inity : int) =
  object
    val mutable posx : int = initx
    val mutable posy : int = inity

    (* get_pos () -- Returns a tuple of the positions. *)
    method get_pos : int * int = posx, posy

    method set_pos (x, y : int * int) : unit =
      posx <- x;
      posy <- y

    (* move center a -- Attempts to complete the action with the tetrimino.
                          Returns true if the action succeeds, false if not. *)
    method move ((cx, cy) : int * int) (a : action) : int * int =
      match a with
      | Left -> (posx - 1), posy
      | Down -> posx, (posy - 1)
      | Right -> (posx + 1), posy
      | CW -> (cx + posy - cy), (cy - posx + cx) (* derived from 90 degree rotation matrix *)
      | CCW -> (cx - posy + cy), (cy + posx - cx) (* similarly to above *)
      | Drop
      | NoAction -> (0, 0)

    method add_to_model (m : model) : unit =
      m.(posy).(posx) <- true
 end

class tetrimino (p : piece)=
  object (this)
    val center = new square 4 20
    val mutable square_list = []

    initializer
      square_list <- center ::
      (match p with
       | I -> [new square 3 20; new square 5 20; new square 6 20]
       | J -> [new square 3 21; new square 3 20; new square 5 20]
       | L -> [new square 3 20; new square 5 20; new square 5 21]
       | O -> [new square 4 21; new square 5 20; new square 5 21]
       | S -> [new square 3 20; new square 4 21; new square 5 21]
       | T -> [new square 3 20; new square 4 21; new square 5 20]
       | Z -> [new square 3 21; new square 4 21; new square 5 20])

    method get_pos : (int * int) list =
      List.map (fun sq -> sq#get_pos) square_list

    (* sq_full pos m -- Returns true if the square in the model is filled. *)
    method sq_full ((posx, posy) : int * int) (m : model) : bool =
      posx < 0 || posx > 9 || posy < 0 || (posy < 20 && m.(posy).(posx))

    method move (m : model) (a : action) : bool =
      if a = NoAction then false
      else if a = Drop then (this#move m Down) && (this#move m Drop)
      else
        let center = (List.hd square_list)#get_pos in
        let shifted = List.map (fun sq -> sq#move center a) square_list in
        if List.fold_right (fun pos -> (||) (this#sq_full pos m)) shifted false then false
        else
          (List.iter2 (fun sq pos -> sq#set_pos pos) square_list shifted; true)

      (*if a = NoAction then false
      else if a = Drop then (this#move m Down) && (this#move m Drop)
      else if List.fold_right (fun sq -> (||) (sq#intersect (List.hd square_list)#get_pos m a)) square_list false then false
      else
        (List.iter (fun sq -> sq#move (List.hd square_list)#get_pos m a) square_list; true)*)

    method add_to_model (m : model) : unit =
      List.iter (fun sq -> sq#add_to_model m) square_list
  end

(*
class ipiece (initx : int) (inity : int) =
  object (this)
    inherit tetrimino initx inity as super

    val ori = new O.orientation

    initializer
      orientation


*)