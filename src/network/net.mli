open Bitcoinml

type t 

val init : unit -> t
val loop : t -> unit

val connect : t -> string -> int -> Hash.t -> bool
val disconnect : t -> Hash.t -> bool