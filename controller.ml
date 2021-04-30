(*
                         CS 51 Final Project
                            OCaml Tetris
                        Visualizing the game
 *)
open Config ;;
module G = Graphics ;;

let on_capture () =
  let event = G.wait_next_event [Key_pressed] in
  match event.key with
  | 'w' ->
  | 'a' ->
  | 's' ->
  | 'd' ->
  (if event.keypressed then (G.draw_string (String.make 1 event.key)));
  loop ()

let _ =
  G.open_graph "";
  loop ();
  G.close_graph ();