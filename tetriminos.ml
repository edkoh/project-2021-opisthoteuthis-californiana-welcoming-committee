(*
                         CS 51 Final Project
                            OCaml Tetris

                             Tetriminos
 *)

open Config ;;
module O = Orientation ;;
module Viz = Visualization ;;

class tetrimino =
  object (self)
    val mutable posx : int = 5
    val mutable posy : int = 19

    method move_down () = posy <- posy - 1

    method move_left () = (); 
    method move_right () = (); 

    method gen_model : bool array array = 
      let m = Array.make_matrix cBOARD_X cBOARD_Y false in
      m.(posx).(posy) <- true; m



  end

(*
class ipiece (initx : int) (inity : int) =
  object (self)
    inherit tetrimino initx inity as super

    val ori = new O.orientation

    initializer
      orientation


*)