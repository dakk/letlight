open Protocol;;
open Network;;
open Printf;;
open Bitcoinml;;
open Letchain;;

let rec loop lc last_block =
  Unix.sleep 4;
  let nlb = Letchain.get_last_block lc in
  (if nlb.Block.header.hash <> last_block.Block.header.hash then
    printf "<letlightd> new block: last is %s %d\n%!" nlb.header.hash (Int64.to_int (Letchain.get_height lc));
  );
  loop lc nlb
;;
  
let main () =
	let lc = Letchain.init ~loglevel:0 (PrunedNode (1024)) ~network:"XBT" in
  Letchain.is_synchronized lc;

  printf "<letlightd> network: %s\n%!" @@ Params.name_of_network (Letchain.get_network lc);
  printf "<letlightd> directory: %s\n%!" (Letchain.get_directory lc);
  printf "<letlightd> starting from block %s %d\n%!" (Letchain.get_last_block lc).header.hash (Int64.to_int (Letchain.get_height lc));

  let net = Net.init () in
  (*let net_thread = Thread.create (fun lc -> ) in*)

  loop lc @@ Letchain.get_last_block lc;

  Letchain.stop lc;
  Letchain.join_threads lc
;;


main ();;