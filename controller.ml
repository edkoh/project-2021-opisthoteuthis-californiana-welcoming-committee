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
let rec loop () =
  let event = G.wait_next_event [Key_pressed] in
  (if event.keypressed then (Printf.printf "%c\n" event.key) else Printf.printf "_");
  loop ()

let _ =
  G.open_graph "";
  loop ();
  G.close_graph ();