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
    | 0 -> new ipiece
    | 1 -> new jpiece
    | 2 -> new lpiece
    | 3 -> new opiece
    | 4 -> new spiece
    | 5 -> new tpiece
    | 6 -> new zpiece
    | _ -> failwith "No such piece matches random generator output" ;;


exception GameOver of string;;

let _ =
  V.init_graph ();
  (* comment *)
  let m = Array.make_matrix cBOARD_Y cBOARD_X 0 in
  let score = ref 0 in
  let level = ref 1 in

  try
  let queued = ref (random_piece ()) in
  while true do
    let piece = !queued in
    queued := random_piece ();
    while piece#move m Down do
      V.render_model m;
      V.render_text !score !level;
      piece#draw;
      !queued#draw_queue;
      let tickspeed = level_tick_formula !level in (* slight optimization *)
      let now = Sys.time () in
      let dropped = ref false in
      while (Sys.time () -. now < tickspeed) && not !dropped do
        let input = on_capture () in
        if piece#move m input then (
          V.render_model m;
          V.render_text !score !level;
          piece#draw;
          !queued#draw_queue;
        );
        if input = Drop then dropped := true
      done;
    done;
    if List.exists (fun (_, y) -> y >= cBOARD_Y) piece#get_pos then
      raise (GameOver ("GAME OVER. FINAL SCORE: " ^ string_of_int !score ^ "\n"))
      (* implement game over screen if there was more time*)
    else
      piece#add_to_model m;
      score := !score + (clear_lines m);
      level := !score / 5 + 1;
      (* G.sound 800 200; Graphics sound function not compatible with system *)
  done;
  with
    | GameOver s -> Printf.printf "%s" s