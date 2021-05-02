(*
                         CS 51 Final Project
                            OCaml Tetris

                               Tetris
 *)

open Config ;;
open Model ;;
open Controller ;;
open Tetriminos ;;
(* module G = Graphics ;; for sound *)
module V = Visualization ;;

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

let random_piece : unit -> piece =
  Random.self_init ();
  fun () ->
    match Random.int 7 with
    | 0 -> I
    | 1 -> J
    | 2 -> L
    | 3 -> O
    | 4 -> S
    | 5 -> T
    | 6 -> Z
    | _ -> failwith "No such piece matches random generator output" ;;

let _ =
  V.init_graph ();
  (* comment *)
  let m = Array.make_matrix cBOARD_Y cBOARD_X false in
  let score = ref 0 in

  while true do
    let piece = new tetrimino (random_piece ()) in
    while piece#move m Down do
      V.render_model m !score;
      V.render_piece piece;
      let now = Sys.time () in
      while Sys.time () -. now < cTICK_SPEED do
        if piece#move m (on_capture ()) then (
          V.render_model m !score;
          V.render_piece piece
        );
      done;
    done;
    piece#add_to_model m;
    score := !score + (clear_lines m);
    (* G.sound 800 200; Graphics sound function doesn't work *)
  done;