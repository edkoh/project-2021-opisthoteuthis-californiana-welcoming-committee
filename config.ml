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
  | X ;;

type model = bool array array ;;


let cTICK_SPEED = 200. /. 1000. ;;
let cBOARD_X = 10 ;;
let cBOARD_Y = 20 ;;
let cBLOCK_SIZE = 40 ;;
