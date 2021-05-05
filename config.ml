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

(* tetromino colors *)
let iColor = 0x66ffff ;;
let jColor = 0x3366ff ;;
let lColor = 0xff9933 ;;
let oColor = 0xffff00 ;;
let sColor = 0x32CD32 ;;
let tColor = 0xcc00cc ;;
let zColor = 0xff0000 ;;

let init_tick_speed = 0.4 ;;
(* formula to determine tick speed for each level *)
let level_tick_formula level = init_tick_speed /. (float_of_int level) *. 1.3 ;;

let cBOARD_X = 10 ;;
let cBOARD_Y = 20 ;;
let cBLOCK_SIZE = 35 ;;