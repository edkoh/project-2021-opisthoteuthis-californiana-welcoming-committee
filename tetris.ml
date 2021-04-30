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
    while not (piece#intersect m Down) do
      piece#move_down;
      V.render_model m;
      V.render_piece piece; 
      Unix.sleepf cTICK_SPEED;
    done;
    piece#add_to_model m;
  done;
