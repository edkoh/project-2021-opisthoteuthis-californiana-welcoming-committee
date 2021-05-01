(*
                         CS 51 Final Project
                            OCaml Tetris

                             Tetriminos
 *)

open Config ;;
module O = Orientation ;;

class square (initx : int) (inity : int) =
  object (this)
    val mutable posx : int = initx
    val mutable posy : int = inity

    (* get_pos () -- Returns a tuple of the positions. *)
    method get_pos : int * int = posx, posy

    (* intersect m a -- Returns true if the action will intersect the model. *)
    method intersect ?(center = (posx, posy)) (m : model) (a : action) : bool =
      match a with
      | Left -> if posx <= 0 then true else m.(posy).(posx - 1)
      | Down -> if posy <= 0 then true else m.(posy - 1).(posx) (* TODO: find better way? *)
      | Right -> if posx >= 9 then true else m.(posy).(posx + 1)
      (*| CW ->
      | CCW ->*)
      | Drop
      | NoAction -> false

    (* move m a center -- Attempts to complete the action with the tetrimino.
                          Returns true if the action succeeds, false if not. *)
    method move ?(center = (posx, posy)) (m : model) (a : action) : bool =
      if this#intersect m a then false else
      match a with
      | Left -> (posx <- posx - 1; true)
      | Down -> (posy <- posy - 1; true)
      | Right -> (posx <- posx + 1; true)
      (*| CW ->
      | CCW ->*)
      | Drop -> (this#move m Down) && (this#move m Drop)
      | NoAction -> false (* TODO: do later *)

    method add_to_model (m : model) : unit =
      m.(posy).(posx) <- true
 end

class tetrimino (p : piece)=
  object (this)
    val mutable center = new square 5 20
    val square_list = center ::
      (match p with
       | X -> [new square 4 20])

    method get_pos : int * int list = List.map (fun sq -> sq#get_pos) square_list

    method move (m : model) (a : action) : bool =
      List.fold_left (fun sq -> (&&) (sq#move m a)) true square_list

    method add_to_model (m : model) : unit =
      List.iter (fun sq -> sq#add_to_model) square_list
  end

class twopiece =
  object (this)
    inherit tetrimino X
  end

(*
class ipiece (initx : int) (inity : int) =
  object (this)
    inherit tetrimino initx inity as super

    val ori = new O.orientation

    initializer
      orientation


*)