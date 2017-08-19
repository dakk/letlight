module Init : sig
  type t = {
    global_features : int;
    local_features  : int;
  }

  val parse     : Bitstring.t -> t
  val serialize : t -> bytes
end

module Error : sig
  type t = {
    channel_id   : bytes;
    data         : bytes;
  }

  val parse     : Bitstring.t -> t
  val serialize : t -> bytes
end

module Ping : sig
  type t = {
    pong_len  : int;
    data      : bytes;
  }

  val parse     : Bitstring.t -> t
  val serialize : t -> bytes
end

module Pong : sig
  type t = {
    data : bytes;
  }

  val parse     : Bitstring.t -> t
  val serialize : t -> bytes
end

type t = 
| INIT of Init.t
| ERROR of Error.t
| PING of Ping.t
| PONG of Pong.t
| INVALID of bytes

val parse     : bytes -> t
val serialize : t -> bytes