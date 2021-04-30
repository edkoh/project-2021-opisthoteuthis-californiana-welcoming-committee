(*
                         CS 51 Final Project
                            OCaml Tetris

                               Tetris
 *)

open Config ;;
module V = Visualization ;;
module Tms = Tetriminos ;;

let m = Array.make_matrix cBOARD_X cBOARD_Y false ;;

let _ =
  V.init_graph ();

  while true do
    for x = 19 downto 0 do
      m.(5).(x) <- true;
      V.render m;
      Unix.sleepf cTICK_SPEED;
    done;
  done;
