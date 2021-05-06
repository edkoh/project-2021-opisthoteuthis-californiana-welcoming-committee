(*
                         CS 51 Final Project
                            OCaml Tetris

                        Visualizing the game
 *)

open Config ;;
open Model ;;
module G = Graphics ;;

let screenx = cBOARD_X * cBLOCK_SIZE ;;
let screeny = cBOARD_Y * cBLOCK_SIZE ;;
(* dimensions of "displays" *)
let displayX = 5 * cBLOCK_SIZE ;;
let displayY = 3 * cBLOCK_SIZE ;;

(* draw_grid_lines () -- Draws all the necessary grid lines. *)
let draw_grid_lines () =
  G.set_color G.black;
  (* draw vertical lines *)
  for i = 0 to cBOARD_X do
    G.moveto (i * cBLOCK_SIZE) 0;
    G.lineto (i * cBLOCK_SIZE) screeny;
  done;

  (* divider for queue *)
  G.moveto (screenx + cBLOCK_SIZE/3) 0;
  G.lineto (screenx + cBLOCK_SIZE/3) (screeny + displayY);
  G.moveto (screenx + cBLOCK_SIZE * 2/3) 0;
  G.lineto (screenx + cBLOCK_SIZE * 2/3) (screeny + displayY);

  (* draw horizontal lines *)
  for i = 0 to cBOARD_Y do
    G.moveto 0 (i * cBLOCK_SIZE);
    G.lineto screenx (i * cBLOCK_SIZE);
  done; ;;

(* init_graph () -- Gets all the visuals set up for the game. *)
let init_graph () =
  G.open_graph (" " ^ string_of_int (screenx + displayX) ^ "x" ^ string_of_int (screeny + displayY));
  G.set_window_title "OCaml Tetris!";
  G.draw_rect 0 0 (screenx + displayX) (screeny + displayY);
  draw_grid_lines () ;;

(* fill_square (x, y) c -- Fills the given square with the color. *)
let fill_square ((x, y) : int * int) (c : G.color) : unit =
  G.set_color c;
  G.fill_rect (x * cBLOCK_SIZE) (y * cBLOCK_SIZE) cBLOCK_SIZE cBLOCK_SIZE ;;

(* render_model m -- Renders a model with two for loops.
                     If a square is non-zero in the model then it gets filled.
                     Our model takes the form row/column (y, x), but the fill_square
                     function takes column/row (x, y), so that's why the i and j switch.
                     Would write the differently if we were reimplementing. *)
let render_model (m : model) =
  G.clear_graph ();
  for i = 0 to (Array.length m) - 1 do
    for j = 0 to (Array.length m.(i)) - 1 do
      if (m.(i).(j) <> 0) then fill_square (j, i) m.(i).(j);
    done;
  done;
  draw_grid_lines () ;;

(* render_text score level -- Draws the text for controls, score, and level. *)
let render_text (score : int) (level : int) : unit =
  G.set_color G.black;
  G.moveto 0 (screeny + displayY - 20);
  G.draw_string " CONTROLS:  Move: WASD   |   Rotate:  ccw | cw:  <  |  >"; (* Controls display *)
  G.moveto 0 (screeny + displayY - 40);
  G.draw_string (" SCORE: " ^ string_of_int score); (* Score display *)
  G.moveto 0 (screeny + displayY - 60);
  G.draw_string (" LEVEL: " ^ string_of_int level); (* level display *) ;;