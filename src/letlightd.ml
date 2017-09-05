open Protocol;;
open Printf;;
open Bitcoinml;;
open Letchain;;

type t = {
  nodes : (Hash.t, Node.t) Hashtbl.t;
};;

let init () = {
  nodes = Hashtbl.create 4
};;

let rec loop ll lc last_block =
  Unix.sleep 4;
  let nlb = Letchain.get_last_block lc in
  (if nlb.Block.header.hash <> last_block.Block.header.hash then
    printf "<letlightd> new block: last is %s %d\n%!" nlb.header.hash (Int64.to_int (Letchain.get_height lc));
  );
  loop ll lc nlb
;;
  
let main () =
	let lc = Letchain.init ~loglevel:0 (PrunedNode (1024)) ~network:"XBT" in
  Letchain.is_synchronized lc;

  printf "<letlightd> network: %s\n%!" @@ Params.name_of_network (Letchain.get_network lc);
  printf "<letlightd> directory: %s\n%!" (Letchain.get_directory lc);
  printf "<letlightd> starting from block %s %d\n%!" (Letchain.get_last_block lc).header.hash (Int64.to_int (Letchain.get_height lc));

  let rpc = Rpc.init 9090 in
  loop (init ()) lc @@ Letchain.get_last_block lc;

  Letchain.stop lc;
  Letchain.join_threads lc
;;


main ();;