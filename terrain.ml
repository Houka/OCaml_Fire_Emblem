open Jsonparser

type t_stats = {name:string; atkBonus:int; defBonus:int; img: Sprite.image}

type terrain = Impassable | Sea of t_stats | Plain of t_stats
              | Mountain of t_stats | City of t_stats
              | Forest of t_stats

let get_terrain (classnum:int) : terrain =
  if classnum = 0 then Impassable else
    let terrain_list = get_all_terrain_data () in
    let info = List.assoc classnum terrain_list in
    let terrain_type = info.Jsonparser.terrain_type in
    let terrain_stats = {name = info.Jsonparser.name;
      atkBonus = info.Jsonparser.atkBonus; defBonus = info.Jsonparser.defBonus;
      img = Sprite.(resize (get_image info.Jsonparser.img)
                            Constants.gridSide Constants.gridSide)} in
    print_string "creating terrain \n";
    match terrain_type with
    | "impassable" -> Impassable
    | "sea" ->        Sea terrain_stats
    | "plain" ->      Plain terrain_stats
    | "mountain" ->   Mountain terrain_stats
    | "city" ->       City terrain_stats
    | "forest" ->     Forest terrain_stats
    | _ -> failwith "Invalid terrain type in json"

let get_atkBonus (terrain:terrain): int =
  match terrain with
  | Impassable -> 0
  | Sea t_stats
  | Plain t_stats
  | Mountain t_stats
  | City t_stats
  | Forest t_stats -> t_stats.atkBonus

let get_defBonus (terrain:terrain): int =
  match terrain with
  | Impassable -> 0
  | Sea t_stats
  | Plain t_stats
  | Mountain t_stats
  | City t_stats
  | Forest t_stats -> t_stats.defBonus

let draw t (x,y) : unit =
  let x' = x*Constants.gridSide in
  let y' = (-y-1+Constants.(gameHeight/gridSide))*Constants.gridSide in
  match t with
  | Impassable ->
    let result =
      try Sprite.(draw
                  (resize (get_image "images/terrains/rock.png")
                    Constants.gridSide Constants.gridSide)
                  (x',y')) with
      | _ ->
        Graphics.set_color 0x000000;
        Graphics.fill_rect x' y' Constants.gridSide Constants.gridSide in
      result
  | Sea t_stats | Plain t_stats | Mountain t_stats | City t_stats | Forest t_stats ->
    let img = t_stats.img in
    Sprite.(draw img (x',y'))