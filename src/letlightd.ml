open Letchain;;
open Protocol;;


let main () =
	let lc = Letchain.init ~loglevel:3 (PrunedNode (1024)) in
  Letchain.is_synchronized lc;

  Letchain.join_threads lc
;;


main ();;