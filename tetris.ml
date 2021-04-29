(*
                         CS 51 Final Project
                            OCaml Tetris

                               Tetris
 *)

open Config ;;
module V = Visualization ;;

let m = Array.make_matrix 10 20 false ;;

let _ =
  V.init_graph ();

  for x = 19 downto 0 do
    m.(5).(x) <- true;
    V.render m;
    Unix.sleepf cTICK_SPEED;
  done;




