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
      | NoAction -> (0, 0)
      | Drop -> failwith "Squares shouldn't drop"

    method add_to_model (m : model) : unit =
      m.(posy).(posx) <- true
  end

class tetrimino (p : piece)=
  object (this)
    val center = new square ((cBOARD_X - 1)/2) (cBOARD_Y + 1)
    val mutable square_list = []

    initializer
      square_list <- center ::
      (let (cx, cy) = center#get_pos in      (* Chose to sacrifice brevity in order to remove hardcoding *)
        match p with
       | I -> [new square (cx - 1) cy;
               new square (cx + 1) cy;
               new square (cx + 2) cy]
       | J -> [new square (cx - 1) (cy + 1);
               new square (cx - 1) cy;
               new square (cx + 1) cy]
       | L -> [new square (cx - 1) cy;
               new square (cx + 1) cy;
               new square (cx + 1) (cy + 1)]
       | O -> [new square cx (cy + 1);
               new square (cx + 1) cy;
               new square (cx + 1) (cy + 1)]
       | S -> [new square (cx - 1) cy;
               new square cx (cy + 1);
               new square (cx + 1) (cy + 1)]
       | T -> [new square (cx - 1) cy;
               new square cx (cy + 1);
               new square (cx + 1) cy]
       | Z -> [new square (cx - 1) (cy + 1);
               new square cx (cy + 1);
               new square (cx + 1) cy])

    method get_pos : (int * int) list =
      List.map (fun sq -> sq#get_pos) square_list

    (*  *)
    method move (m : model) (a : action) : bool =
      if a = NoAction then false
      else if a = Drop then (this#move m Down) && (this#move m Drop)
      else
        let cpos = center#get_pos in
        let shifted = List.map (fun sq -> sq#move cpos a) square_list in
        if List.fold_right (fun pos -> (||) (sq_full pos m)) shifted false then false
        else
          (List.iter2 (fun sq pos -> sq#set_pos pos) square_list shifted; true)

    method add_to_model (m : model) : unit =
      List.iter (fun sq -> sq#add_to_model m) square_list
  end