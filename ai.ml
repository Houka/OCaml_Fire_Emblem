open Feunit
open Terrain

let update (units:feunit list ref) (terrains:terrain list ref) : unit =
  failwith "TODO"

(* finds enemy units to move*)
let find_enemy_units (units:feunit list) : feunit list = failwith "TODO"

(* Algorithm 1: Rush nearest*)
let rush_nearest (units:feunit list ref) (terrains:terrain list ref) : unit =
  failwith "TODO"

(* Algorithm 2: Swarm Lowest Health *)
let attack_weakest (units:feunit list ref) (terrains:terrain list ref) : unit =
  failwith "TODO"

(* Algorithm 3: Focus On Easiest Unit To Take Down *)
let focus_super_effective (units:feunit list ref) (terrains:terrain list ref) : unit =
  failwith "TODO"