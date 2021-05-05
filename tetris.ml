(*
                         CS 51 Final Project
                            OCaml Tetris

                               Tetris
 *)

open Config ;;
open Model ;;
open Controller ;;
open Tetromino ;;
module V = Visualization ;;

let random_piece : unit -> tetromino =
  Random.self_init ();
  fun () ->
    match Random.int 7 with
    | 0 -> new tetromino iOther iColor
    | 1 -> new tetromino jOther jColor
    | 2 -> new tetromino lOther lColor
    | 3 -> new tetromino oOther oColor
    | 4 -> new tetromino sOther sColor
    | 5 -> new tetromino tOther tColor
    | 6 -> new tetromino zOther zColor
    | _ -> failwith "No such piece matches random generator output" ;;

let _ =
  V.init_graph ();
  (* comment *)
  let m = Array.make_matrix cBOARD_Y cBOARD_X 0 in
  let score = ref 0 in
  let level = ref 1 in

  while true do
    let piece = random_piece () in
    while piece#move m Down do
      V.render_model m;
      V.render_text !score !level;
      piece#draw;
      let tickspeed = level_tick_formula !level in (* slight optimization *)
      let now = Sys.time () in
      let dropped = ref false in
      while (Sys.time () -. now < tickspeed) && not !dropped do
        let input = on_capture () in
        if piece#move m input then (
          V.render_model m;
          V.render_text !score !level;
          piece#draw;
        );
        if input = Drop then dropped := true
      done;
    done;
    if List.exists (fun (_, y) -> y >= cBOARD_Y) piece#get_pos then
      failwith ("GAME OVER. FINAL SCORE: " ^ string_of_int !score)
      (* implement game over screen if there was more time *)
    else
      piece#add_to_model m;
      score := !score + (clear_lines m);
      level := !score / 5 + 1;
      (* G.sound 800 200; Graphics sound function not compatible with system *)
  done;