let simple =
  <:value< { a = if 2 = 2 then 2 else 3;
             b = (match nullable 2 with null -> 0 | n -> 2 * n);
             c = match null with null -> 0 | n -> n } >>

let row =
  <:value<
    if false
    then {a = 1; b = 2}
    else {a = 2; b = 1} >>

let duplication x =
  <:value<
    match
      (match x with
         | null -> null
         | x' -> nullable {a = nullable x'; b = nullable x'; c = nullable x'})
    with
      | null -> {a = null; b = null; c = null}
      | row -> row
    >>

let () =
  let dbh = PGOCaml.connect () in
  let res = Query.Simple.view_one ~log:stdout dbh << $simple$ >> in
  Printf.printf "a:%d\tb:%d\tc:%d\n" res#!a res#!b res#!c;
  let res = Query.Simple.view_one dbh << $row$ >> in
  Printf.printf "a:%d\tb:%d\n" res#!a res#!b;
  print_endline (Sql.sql_of_view (Sql.View.one (duplication <:value< 1 + 1 >>)));
  PGOCaml.close dbh
