open Feunit
open Terrain
open Constants
open PathFinder


(*Returns list of move action given an unit. Move action is limited by the given
  unit's movRange*)
let move (d: dest_path) (enemy: feunit) : action list =
  let es = match enemy with | Enemy s | Ally s -> s | _ -> failwith "invalid" in
  let path = d.path in
  let rec loop p actions c =
    match p with
    | [] -> actions
    | (x,y)::tl ->
        if c >= (es.movRange - 1) then
          [Move (d.start, (x, y))]
        else
          loop tl actions (c + 1)
  in loop path [] 0

(*Returns list of move action ending with an attack action. List of action is
  limited by given unit's movRange and atkRange*)
let move_attack (d: dest_path) (enemy: feunit) : action list =
  let es = match enemy with | Enemy s | Ally s -> s | _ -> failwith "invalid" in
  let path = d.path in
  let rec loop p actions =
    match p with
    | [] -> actions
    | (x1,y1)::(x2, y2)::(x3, y3)::[] ->
        if es.atkRange > 1 then
          let m = Move (d.start, (x1, y1)) in
          let a = Attack ((x1, y1), (x3, y3)) in
          [m;a]
        else
          let m = Move (d.start, (x2, y2)) in
          let a = Attack ((x2, y2), (x3, y3)) in
          [m;a]
    | (x, y)::tl ->
        loop tl actions
  in loop path []

(*Returns list of unit/target that has the lowest health. If there are multiple
  units of lowest health, it returns all of those units*)
let find_lowest (units: feunit matrix) (dl: dest_path list) : dest_path list =
  let lowest_hp = ref max_int in
  List.fold_left (
    fun a x ->
       let u = match (grab units x.destination) with
               | Enemy s | Ally s -> s | _ -> failwith "invalid" in
       if a = [] then
         (lowest_hp := u.hp; [x])
       else
         let hp = u.hp in
         if hp < !lowest_hp then
           (lowest_hp := hp; [x])
         else if hp = !lowest_hp then
           x::a
         else a
  ) [] dl


(*Returns list of unit/target that is the weakest. Returns only one unit*)
let find_effective (units: feunit matrix) (weapon: string)
(dl: dest_path list) : dest_path =
  let fst_w = (List.nth dl 0) in
  List.fold_left (
    fun a x ->
       let w = match (grab units x.destination) with
               | Enemy s | Ally s -> s.weapon | _ -> failwith "invalid" in
       let aw = match (grab units a.destination) with
               | Enemy s | Ally s -> s.weapon | _ -> failwith "invalid" in
       if weapon = "sword" then
         if (w = "axe" || w = "sword" || w = "bow") &&
         (not (aw = "axe")) then
           x
         else if w = "lance" &&
         (not (aw = "sword" || aw = "axe" || aw = "bow")) then
           x
         else
           a
       else if weapon = "lance" then
         if (w = "sword" || w = "lance" || w = "bow") &&
         (not (aw = "sword")) then
           x
         else if w = "axe" &&
         (not (aw = "lance" || aw = "sword" || aw = "bow")) then
           x
         else
           a
       else if weapon = "axe" then
         if (w = "lance" || w = "axe" || w = "bow") &&
         (not (aw = "lance")) then
           x
         else if w = "sword" &&
         (not (aw = "lance" || aw = "axe" || aw = "bow")) then
           x
         else
           a
       else
           a
  ) fst_w dl

let update (units:feunit matrix) (terrains: terrain matrix)
: action list  =
  (*Finds the index of enemy and ally unit in units*)
  let (e, a) = find_units units in
  let enemies = e in
  let players = a in

  (*Loop through enemy feunit *)
  let rec create_action enemy =
    match enemy with
    | [] -> []
    | hd::tl ->
        let paths =
          List.map (fun x -> shortest_path hd x units terrains) players in
        let e = match (grab units hd) with
                | Enemy s | Ally s -> s | _ -> failwith "invalid" in
        let within =
          List.filter (fun d -> d.cost <= (e.atkRange + e.movRange)) paths in
        if List.length within > 1 then
          (*Check healths, if more than one target then finds most effectiveness*)
          let targets = find_lowest units within in
          if List.length targets > 1 then
            let weapon = match (grab units hd) with
                         | Enemy s | Ally s -> s.weapon
                         | _ -> failwith "invalid" in
            let target = find_effective units weapon targets in
            let actions = move_attack target (grab units hd) in
            actions@(create_action tl)
          else
            let actions =
              match targets with
              | [] -> []
              | dh::_ -> move_attack dh (grab units hd)
            in
            actions@(create_action tl)
        else if List.length within = 1 then
          (*Atack closest Unit*)
          let actions =
            match within with
            | [] -> []
            | dh::_ -> move_attack dh (grab units hd)
          in
          actions@(create_action tl)
        else
          (*Move towards closest Unit*)
          let closest =
          List.fold_left (fun a x -> if x.cost < a.cost then x else a)
          (List.nth paths 0) paths in
          let actions = move closest (grab units hd) in
          actions@(create_action tl)
  in
  create_action enemies