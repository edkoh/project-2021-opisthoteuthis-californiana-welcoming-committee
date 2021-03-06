(*
                         CS 51 Final Project
                            OCaml Tetris

                               Model
                File containing functionality for models
 *)

open Config ;;

(* new model file *)
type model = int array array ;;

(* sq_full pos m -- Returns true if the square in the model is filled or out of bounds. *)
let sq_full ((posx, posy) : int * int) (m : model) : bool =
  posx < 0 || posx > cBOARD_X - 1 || posy < 0 || (posy < cBOARD_Y && (m.(posy).(posx)) <> 0) ;;

(* clear_lines m -- Destructively clears all the lines in a model and returns
                    number of lines cleared. *)
let clear_lines (m : model) : int =
  let shift = ref 0 in
  for row = 0 to cBOARD_Y - 1 do
    m.(row - !shift) <- m.(row);
    (*if Array.fold_left (&&) true m.(row) then incr shift*)
    if not (Array.mem 0 m.(row)) then incr shift
  done;
  for row = (cBOARD_Y - !shift) to cBOARD_Y - 1 do
    m.(row) <- Array.make cBOARD_X 0;
  done;
  !shift ;;