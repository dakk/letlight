
type t = {
  chain_hash : Hash.t;
  nodes : (Hash.t * string * int) list;
}

val test_conf : unit -> t