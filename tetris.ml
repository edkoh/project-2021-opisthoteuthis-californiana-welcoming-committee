(*
                         CS 51 Final Project
                            OCaml Tetris

                               Tetris
 *)

open Config ;;
open Tetriminos ;;
module V = Visualization ;;

let _ =
  V.init_graph ();
  let m = Array.make_matrix cBOARD_X cBOARD_Y false in

  while true do
    let piece = new tetrimino in
    while piece#move_down m do
      V.render_model m;
      V.render_piece piece; 
      let now = Sys.time () in
      while Sys.time () -. now < cTICK_SPEED do
      ()
      done;
      (* Unix.sleepf cTICK_SPEED; *)
    done;
    piece#add_to_model m;
  done;
