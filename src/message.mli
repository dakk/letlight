open Bitcoinml
open Bitstring

module Init : sig
  type t = {
    global_features : bytes;
    local_features  : bytes;
  }

  val parse     : Bitstring.t -> t option
  val serialize : t -> bytes
end

module Error : sig
  type t = {
    channel_id   : Hash.t;
    data         : bytes;
  }

  val parse     : Bitstring.t -> t option
  val serialize : t -> bytes
end

module Ping : sig
  type t = {
    pong_len  : int;
    data      : bytes;
  }

  val parse     : Bitstring.t -> t option
  val serialize : t -> bytes
end

module Pong : sig
  type t = {
    data : bytes;
  }

  val parse     : Bitstring.t -> t option
  val serialize : t -> bytes
end


type t = 
| INIT of Init.t
| ERROR of Error.t
| PING of Ping.t
| PONG of Pong.t

val parse     : bytes -> t option
val serialize : t -> bytes