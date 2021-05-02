(*
                         CS 51 Final Project
                            OCaml Tetris

                               Tetris
 *)

open Config ;;
open Controller ;;
open Tetriminos ;;
module V = Visualization ;;

let clear_lines (m : model) : unit =
  let shift = ref 0 in
  for row = 0 to cBOARD_Y - 1 do
    (if row + !shift < cBOARD_Y then
      m.(row - !shift) <- m.(row)
    else (m.(row) <- Array.make cBOARD_X false; (* TODO: find a better way? *)
          m.(row - !shift) <- Array.make cBOARD_X false));
    if Array.fold_left (&&) true m.(row) then incr shift
  done;
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
    | _ -> failwith "uh-oh" ;; (* TODO *)

let _ =
  V.init_graph ();
  (* comment *)
  let m = Array.make_matrix cBOARD_Y cBOARD_X false in

  while true do
    let piece = new tetrimino (random_piece ()) in
    while piece#move m Down do
      V.render_model m;
      V.render_piece piece;
      let now = Sys.time () in
      while Sys.time () -. now < cTICK_SPEED do
        if piece#move m (on_capture ()) then (
          V.render_model m;
          V.render_piece piece
        ) else (); (* play sound *)
      done;
    done;
    piece#add_to_model m;
    clear_lines m;
  done;