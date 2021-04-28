(*
                         CS 51 Final Project
                            OCaml Tetris

                        Tetrimino Orientation
*)

class type orientation =
  object
    (* cw -- Rotates clockwise. *)
    method cw : unit
    (* ccw -- Rotates counterclockwise. *)
    method ccw : unit
    (* count -- Returns the current count, initially zero. *)
    method count : int
  end ;;

type ori = float * float ;;

let cw (x1, y1) (x2, y2) =
  x1 +. x2, y1 +. y2 ;;

let scale s (x, y) =
  s *. x, s *. y ;;

let offset (x, y) distance angle =
  x +. distance *. cos angle,
  y +. distance *. sin angle ;;

