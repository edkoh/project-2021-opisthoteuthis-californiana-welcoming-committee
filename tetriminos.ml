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
    method intersect (center : int * int) (m : model) (a : action) : bool =
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
    method move (center : int * int) (m : model) (a : action) : unit =
      match a with
      | Left -> (posx <- posx - 1)
      | Down -> (posy <- posy - 1)
      | Right -> (posx <- posx + 1)
      (*| CW ->
      | CCW ->*)
      | Drop -> ()
      | NoAction -> ()

    method add_to_model (m : model) : unit =
      m.(posy).(posx) <- true
 end

class tetrimino (p : piece)=
  object (this)
    (* val mutable center = new square 5 20 *)
    val square_list = (new square 5 20) ::
      (match p with
       | X -> [new square 4 20])

    method get_pos : (int * int) list = List.map (fun sq -> sq#get_pos) square_list

    method move (m : model) (a : action) : bool =
      if a = NoAction then false
      else if a = Drop then (this#move m Down) && (this#move m Drop)
      else if List.fold_right (fun sq -> (||) (sq#intersect (List.hd square_list)#get_pos m a)) square_list false then false
      else
        (List.iter (fun sq -> sq#move (List.hd square_list)#get_pos m a) square_list; true)

    method add_to_model (m : model) : unit =
      List.iter (fun sq -> sq#add_to_model m) square_list
  end

class twopiece =
  object
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