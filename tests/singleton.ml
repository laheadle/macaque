open Sql

(* let singleton x = << {value = $x$} | >> *)
let singleton x = << {value = $x$} | >>

(* let singleton_option x = << {value = nullable $x$} | >> *)
let singleton_option x = << {value = nullable $x$} | >>

(* let null = << {null = null} | >> *)
let null = << {null = null} | >>

(*

  ocamlbuild -pp 'camlp4o pa_comp.cmo' tests/singleton.inferred.mli
  cat _build/tests/singleton.inferred.mli

*)

let () =
  let dbh = PGOCaml.connect ~database:"base" () in
  List.iter (fun r -> ignore (Sql.Value.getn r#null = None)) (Query.view dbh null);
  List.iter (fun r -> ignore (Sql.Value.getn r#value = Some 1))
    (Query.view dbh (singleton_option <:value< 1 >>))
