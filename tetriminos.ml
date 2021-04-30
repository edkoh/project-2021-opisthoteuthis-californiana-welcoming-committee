(*
                         CS 51 Final Project
                            OCaml Tetris

                             Tetriminos
 *)

open Config ;;
module O = Orientation ;;

class tetrimino =
  object (this)
    val mutable posx : int = 5
    val mutable posy : int = 20

    method get_pos : int * int = posx, posy

    method intersect (m : model) (a : action) : bool = 
      match a with
      | Down -> if posy <= 0 then true else m.(posx).(posy - 1) (* TODO: find better way? *)
      | _ -> false (* do later *)

    method move (m : model) (a : action) : bool =
      if this#intersect m a then false else
      match a with
      | Down -> (posy <- posy - 1; true)
      | _ -> false (* TODO: do later *)

    method move_down (m : model) : bool = 
      if this#intersect m Down then false else (posy <- posy - 1; true)

    method move_left () = (); 
    method move_right () = (); 

    method add_to_model (m : model) : unit = 
      m.(posx).(posy) <- true
    (*
    method gen_model : bool array array = 
      let m = Array.make_matrix cBOARD_X cBOARD_Y false in
      m.(posx).(posy) <- true; m
      *)
  end

(*
class ipiece (initx : int) (inity : int) =
  object (self)
    inherit tetrimino initx inity as super

    val ori = new O.orientation

    initializer
      orientation


*)