open Bitcoinml;;

type t = {
  nodes: (Hash.t, Node.t) Hashtbl.t
};;

let init () = {
  nodes= Hashtbl.create 4
};;

let loop n = 
	while true do
    Unix.sleep 2
  done
;;


let connect n host port nodeid = true;;

let disconnect n nodeid = true;;