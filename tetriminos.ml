(*
                         CS 51 Final Project
                            OCaml Tetris

                             Tetriminos
 *)

open Config ;;
module O = Orientation ;;

class square =
  object (this)
    val mutable posx : int = 5
    val mutable posy : int = 20

    (* get_pos () -- Returns a tuple of the positions. *)
    method get_pos : int * int = posx, posy

    (* intersect m a -- Returns true if the action will intersect the model. *)
    method intersect (m : model) (a : action) : bool =
      match a with
      | Left -> if posx <= 0 then true else m.(posy).(posx - 1)
      | Down -> if posy <= 0 then true else m.(posy - 1).(posx) (* TODO: find better way? *)
      | Right -> if posx >= 9 then true else m.(posy).(posx + 1)
      | Drop
      | NoAction -> false

    (* move m a -- Attempts to complete the action with the tetrimino.
                   Returns true if the action succeeds, false if not. *)
    method move (m : model) (a : action) : bool =
      (* if this#intersect m a then false else *)
      match a with
      | Left -> (posx <- posx - 1; true)
      | Down -> (posy <- posy - 1; true)
      | Right -> (posx <- posx + 1; true)
      | Drop -> (this#move m Down) && (this#move m Drop)
      | NoAction -> false (* TODO: do later *)

    method add_to_model (m : model) : unit =
      m.(posy).(posx) <- true
 end

class tetrimino =
  object (this)
    (* inherit square *)
    val center = new square
    method move (m : model) (a : action) : bool =
      List.fold_left (fun x -> (&&) (x#move m a)) true
  end

class twopiece =
  object (this)
    inherit tetrimino

  end

(*
class ipiece (initx : int) (inity : int) =
  object (this)
    inherit tetrimino initx inity as super

    val ori = new O.orientation

    initializer
      orientation


*)