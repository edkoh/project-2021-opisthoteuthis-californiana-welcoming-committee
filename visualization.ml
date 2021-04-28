(*
                         CS 51 Final Project
                            OCaml Tetris

                        Visualizing the game
 *)

open Config ;;
module G = Graphics ;;

while true do
  let c = G.read_key () in
  Printf.printf c
done