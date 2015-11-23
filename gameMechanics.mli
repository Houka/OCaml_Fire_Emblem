open Terrain
open Feunit
open Level
(*
 *  The GameMachanics Module:
 *    - Enforces game rules on AI and Player.
 *    - Contains functions that AI and Play must use in order to manipulate
 *      the units on the field. Each function here will represent a legal
 *      move that any player can do.
 *)

(* sets the contents that this module will be working with *)
val set_units: feunit array array -> unit
val set_map: terrain array array -> unit

(* draws the screen after turns are applied *)
val draw: unit -> unit

(* updates the level's current state and all its elements by one turn. Its task
 *  is to gather instructions from all players (AI included) and act on those
 *  instructions. If the instuction provided is an invalid action (based on the
 *  game rules enforced here) then an exception will be thrown
*)
val update: unit -> unit

(* [attack units terrains u1 (x1,y1) u2 (x2,y2)] will enforce game machanics and
    rules as it applies an attack from [u1] at location (x1,y1) to [u2] at
    location (x2,y2). It apply the attack on the units matrix.
    If [u1] attacking [u2] is not allowed it will failwith exception else
    it will apply damage calculated from terrain bonuses and from [u1] to [u2]
    and apply that to the unit matrix.

    A valid attack is the following:
      - [u2] is in the attack range of [u1]
      - [u2] is an enemy of [u1]

    (ex: if a attacks b but b is not in attack range of a then exception is thrown)
    (ex: if a attacks b and the rules allow this then Some c will be returned
      where c is b but with lower hp)
 *)
val attack: feunit -> (int*int) -> feunit -> (int*int) -> unit

(* [move units terrains u1 (x1,y1) (x2,y2))] apply the action of moving from
    [u1]'s current position (x1,y1)to a position (x2, y2). Before it applies
    this movement on the units matrix, it must check that it is a valid move.

    A valid move is the following:
      - at that position, no other unit is there
      - at that position, the terrain is traversible by the unit
      - moving to (x2,y2) is in the range of the unit's movement range
      - there is a terrain at that position
*)
val move: feunit -> int * int -> int*int -> unit

(* [wait u1] alters that unit in the matrix so its endturn attribute says it has finished
    its turn.
 *)
val wait: feunit -> unit