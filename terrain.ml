open Jsonparser

type stats = {name:string; atkBonus:int; defBonus:int; img: Sprite.image}

type terrain = Impassable | Sea of stats | Plain of stats
              | Mountain of stats | City of stats
              | Forest of stats

let get_terrain (classnum:int) : terrain =
  if classnum = 0 then Impassable else
    let terrain_list = get_all_terrain_data () in
    let info = List.assoc classnum terrain_list in
    let terrain_type = info.Jsonparser.terrain_type in
    let terrain_stats = {name = info.Jsonparser.name;
        atkBonus = info.Jsonparser.atkBonus; defBonus = info.Jsonparser.defBonus;
        img = Sprite.get_image info.Jsonparser.img} in
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
  | Sea stats
  | Plain stats
  | Mountain stats
  | City stats
  | Forest stats -> stats.atkBonus

let get_defBonus (terrain:terrain): int =
  match terrain with
  | Impassable -> 0
  | Sea stats
  | Plain stats
  | Mountain stats
  | City stats
  | Forest stats -> stats.defBonus

let draw t (x,y) w h : unit =
  match t with
  | Impassable -> Graphics.set_color 0x000000;
                    Graphics.draw_rect x y w h
  | Sea stats | Plain stats | Mountain stats | City stats | Forest stats ->
      let img = stats.img in
      Sprite.(draw (resize img w h) (x,y))