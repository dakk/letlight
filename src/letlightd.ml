open Letchain;;
open Protocol;;


let main () =
	let lc = Letchain.init ~loglevel:0 (PrunedNode (1024)) in
  Letchain.is_synchronized lc
;;


main ();;