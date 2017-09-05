open Printf;;

let usage () = 
  ()
;;

match (Array.to_list Sys.argv) with
| cp :: "newaddr" :: xl -> printf "newaddr\n%!";
| cp :: "addfunds" :: rawtx :: xl -> printf "addfunds\n%!";
| cp :: "connect" :: host :: port :: node_id :: xl -> printf "connect\n%!";
| cp :: "fundchannel" :: node_id :: amount :: xl -> printf "fundchannel\n%!";
| cp :: "invoice" :: amount :: label :: xl -> printf "invoice\n%!";
| cp :: [] -> usage ();
| cp :: c :: xl -> printf "command '%s' not recognized\n%!" c;
| [] -> usage ();