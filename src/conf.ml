open Bitcoinml;;

type t = {
  chain_hash : Hash.t;
  nodes : (Hash.t * string * int) list;
};;

let test_conf () = {
  chain_hash= "000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f";
  nodes= [("024dce91967c4077e5379e15f21a79d49dfcfbcf8a30abae8e300aff1ce8a61b64","159.203.125.125",9735)]
};;

    