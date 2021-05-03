(*
                         CS 51 Final Project
                            OCaml Tetris

                               Config
 *)

type action =
  | Down
  | Left
  | Right
  | Drop
  | CW
  | CCW
  | NoAction ;;

type piece =
  | I
  | J
  | L
  | O
  | S
  | T
  | Z ;;

let initTick_speed = 0.4 ;;
let level_tick_formula level = initTick_speed /. (float_of_int level) *. 1.3 ;;
let cBOARD_X = 10 ;;
let cBOARD_Y = 20 ;;
let cBLOCK_SIZE = 35 ;;