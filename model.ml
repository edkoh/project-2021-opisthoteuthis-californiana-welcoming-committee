(*
                         CS 51 Final Project
                            OCaml Tetris

                               Model
                  File containing functionality for models
 *)

open Config ;;

(* new model file *)
type model = bool array array ;;

(* sq_full pos m -- Returns true if the square in the model is filled or out of bounds. *)
let sq_full ((posx, posy) : int * int) (m : model) : bool =
  posx < 0 || posx > cBOARD_X - 1 || posy < 0 || (posy < cBOARD_Y && m.(posy).(posx))

let clear (m : model) : unit =
  for i = 0 to (Array.length m) - 1 do
    for j = 0 to (Array.length m.(i)) - 1 do
      m.(i).(j) <- false
    done
  done
;;

let clear_lines (m : model) : int =
  let shift = ref 0 in
  for row = 0 to cBOARD_Y - 1 do
    m.(row - !shift) <- m.(row);
    if Array.fold_left (&&) true m.(row) then incr shift
  done;
  for row = (cBOARD_Y - !shift) to cBOARD_Y - 1 do
    m.(row) <- Array.make cBOARD_X false;
  done;
  !shift
;;