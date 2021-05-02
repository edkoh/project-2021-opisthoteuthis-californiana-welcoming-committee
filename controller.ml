(*
                         CS 51 Final Project
                            OCaml Tetris
                        Visualizing the game
 *)

open Config ;;
module G = Graphics ;;

(* on_capture () -- Returns the action from the corresponding keypress.
                    Returns NoAction if no key is pressed, or if the key
                    does not correspond to an action. *)
let on_capture () : action =
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