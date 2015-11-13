(*
 * The Feunit Module.
 *   - Gets unit data from JsonParser and converts them into an easier to work
 *      with interface by storing the data in abstract data structures.
 *)

(* The types of actions a unit can be instructed to do. *)
type action = Stay | Move | Attack
(* Contains all the stats a typical unit has/needs. Info from JSON. *)
type stats = {name:string; maxHp:int; actions: action list; atkPoints:int;
                    defPoint:int; atkRange:int; movRange:int; img: Images.t;
                    hp:int; atkBonus:int; defBonus:int; atkRangeBonus:int;
                    movRangeBonus:int; x:int; y:int}
(* Represents a fire emblem unit *)
type feunit = Null | Ally of stats | Enemy of stats

(* [getUnit class name (x,y)] returns an arbitrary feunit that is of the class [class]
 *  and sets its init_stats.name to [name]. Unit begin at pos ([x],[y])
 *  (i.e. getUnit "archer" will get an archer, whose stats are found in the JSON)
 *)
val getUnit : string -> string -> (int*int) -> feunit

(* [moveUnit unit (x, y)] gives you an updated feunit where their x and y pos are
 *  now [x] and [y]
 *)
val moveUnit : feunit -> int*int -> feunit

(* self explanatory functions *)
val addAtkBonus : feunit -> int -> feunit
val addDefBonus : feunit -> int -> feunit
val addMovBonus : feunit -> int -> feunit
val addRangeBonus : feunit -> int -> feunit
val addHp : feunit -> int -> feunit (* note: can add negatives, duh *)

(* getters *)
val getTotalAtk : feunit -> int
val getTotalDef : feunit -> int
val getTotalMov : feunit -> int
val getTotalRange : feunit -> int
val getPercentHp : feunit -> int (* hp/maxHp * 100 *)