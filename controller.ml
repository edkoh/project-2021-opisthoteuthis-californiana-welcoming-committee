(*
                         CS 51 Final Project
                            OCaml Tetris
                        Visualizing the game
 *)
open Config ;;
module G = Graphics ;;

let on_capture () : action =
  (*let event = G.wait_next_event [Key_pressed; Poll] in
  match event.key with*)
  if G.key_pressed () then
    match G.read_key () with
    | 'w' -> Drop
    | 'a' -> Left
    | 's' -> Down
    | 'd' -> Right
    | ',' -> CCW
    | '.' -> CW
    | _ -> NoAction
  else NoAction ;;
  (*
  (if event.keypressed then (G.draw_string (String.make 1 event.key)));
  on_capture ()

let _ =
  G.open_graph "";
  on_capture ();
  G.close_graph ();
  *)