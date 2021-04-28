(*
                         CS 51 Final Project
                            OCaml Tetris

                             Tetriminos
 *)

module O = Orientation ;;
module Viz = Visualization ;;

class tetrimino (initx : int) (inity : int) =
  object (self)
    val mutable posx : int = initx
    val mutable posy : int = inity
    val mutable step_size : int = 0

class ipiece (initx : int) (inity : int) =
  object (self)
    inherit tetrimino initx inity as super

    val ori = new O.orientation

    initializer
      orientation

