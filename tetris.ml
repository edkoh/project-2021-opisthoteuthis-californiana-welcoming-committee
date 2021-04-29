(*
                         CS 51 Final Project
                            OCaml Tetris

                               Tetris
 *)

open Config ;;
module V = Visualization ;;

let m = Array.make_matrix cBOARD_X cBOARD_Y false ;;

let _ =
  V.init_graph ();

  for x = 19 downto 0 do
    m.(5).(x) <- true;
    V.render m;
    V.clear m;
    Unix.sleepf cTICK_SPEED;
  done;
