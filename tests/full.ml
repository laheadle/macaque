let full table = <:select< row | row <- $table$ >>

let recette = <:table< recette ( nom text NOT NULL ) >>

let () =
  let do_row row = print_endline (Sql.get row#nom) in
  List.iter do_row (Query.query
                      (PGOCaml.connect ())
                      (full recette))
