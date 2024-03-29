open Feunit
open Terrain

(*
 * The Hub Module:
 *   - Handles drawing information regarding a selected element on the
 *     game screen. (Ex: when the player has his in-game selector on a unit
 *     in the game window, the hub will draw and display the stats of the unit
 *     in a meaningful way--such as a bar to represent current health)
 *)

(* Draw to the GUI all necessary stats on the given unit.
 * If the unit is an Ally, the stats are displayed on top left side.
 * If the unit is an Enemy, the stats are displayed on the top right side.
 *)
val draw_unit_stats : feunit -> unit

(* Draw to the GUI all necessary stats on the given terrain.
 * Stats are displayed on the bottom right side. *)
val draw_terrain_stats : terrain -> unit

(* Draw a display string to the GUI indicating whose turn it currently is.
 * Stats are displayed on the bottom left side. *)
val draw_current_turn: int -> unit

(* Draw a display string to the top level of the GUI. *)
val draw_string: string -> int*int -> unit

(* Return the largest dimensions (width, height) from a list of strings
 * if the longest string is drawn onto the screen. *)
val get_longest_string_dim: (string list) -> int*int

