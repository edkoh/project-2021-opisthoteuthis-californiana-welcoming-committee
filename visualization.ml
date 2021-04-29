(*
                         CS 51 Final Project
                            OCaml Tetris

                        Visualizing the game
 *)

open Config ;;
module G = Graphics ;;

let init_graph () =
  G.open_graph " 400x800";
  G.draw_rect 0 0 400 800;

  (* draw vertical lines *)
  while (G.current_x () < 400) do
    let moved_x = G.current_x () + 40 in
    G.moveto moved_x 0;
    G.lineto moved_x 800;
  done;

  (* draw horizontal lines *)
  G.moveto 0 0;
  while (G.current_y () < 800) do
    let moved_y = G.current_y () + 40 in
    G.moveto 0 moved_y;
    G.lineto 400 moved_y;
  done;
;;


let fill_square (x : int) (y : int) =
  G.set_color G.blue;
  G.fill_rect (x * 40) (y * 40) 40 40;
;;


let render (m : bool array array) : unit =
  for i = 0 to (Array.length m) - 1 do
    for j = 0 to (Array.length m.(i)) - 1 do
      if m.(i).(j) then fill_square i j
    done
  done
;;

  
(*
let _ =
  init_graph ();
  let test = Array.make_matrix 10 20 false in
  test.(1).(1) <- true;
  test.(5).(18) <- true;
  render (test);

  Unix.sleepf 5.;
  *)