(*
                         CS 51 Final Project
                            OCaml Tetris

                        Visualizing the game
 *)

open Config ;;
open Model ;;
open Tetriminos ;;
module G = Graphics ;;

let screenx = cBOARD_X * cBLOCK_SIZE ;;
let screeny = cBOARD_Y * cBLOCK_SIZE ;;

let draw_grid_lines () =
  G.set_color G.black;
  G.moveto 0 0;
  (* draw vertical lines *)
  while (G.current_x () < screenx) do
    let moved_x = G.current_x () + cBLOCK_SIZE in
    G.moveto moved_x 0;
    G.lineto moved_x screeny;
  done;

  (* draw horizontal lines *)
  G.moveto 0 0;
  while (G.current_y () < screeny) do
    let moved_y = G.current_y () + cBLOCK_SIZE in
    G.moveto 0 moved_y;
    G.lineto screenx moved_y;
  done;
;;


let init_graph () =
  G.open_graph (" " ^ string_of_int screenx ^ "x" ^ string_of_int (screeny + 4 * cBOARD_Y));
  G.draw_rect 0 0 screenx (screeny + 4 * cBOARD_Y); (* extra computation here instead of in definition
                                                       of screeny so as to slightly reduce computation*)
  draw_grid_lines ();
;;


let fill_square ((x, y) : int * int) (c : G.color) : unit =
  G.set_color c;
  G.fill_rect (x * cBLOCK_SIZE) (y * cBLOCK_SIZE) cBLOCK_SIZE cBLOCK_SIZE;
;;


let render_model (m : model) (score : int) : unit =
  G.clear_graph ();
  G.moveto (cBOARD_X * cBLOCK_SIZE / 2 - 20) (cBOARD_Y * cBLOCK_SIZE);
  G.draw_string ("SCORE: " ^ string_of_int score);
  for i = 0 to (Array.length m) - 1 do
    for j = 0 to (Array.length m.(i)) - 1 do
      if m.(i).(j) then fill_square (j, i) G.blue;
    done;
  done;
  draw_grid_lines ();
;;

(* perhaps put in tetriminos? *)
let render_piece (t : tetrimino) : unit =
  List.iter (fun pos -> fill_square pos G.blue) t#get_pos;
    (* (List.filter (fun (_,y) -> y < cBOARD_Y) t#get_pos); *)
;;