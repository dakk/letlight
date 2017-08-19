open Bitcoinml
open Bitstring

module Address : sig
  type atype = NONE | IPV4 | IPV6 | TORV2 | TORV3

  type t = {
    address_type: atype;
    address     : bytes;
    port        : int;
  }

  val parse_all : Bitstring.t -> t list
  val parse     : Bitstring.t -> Bitstring.t * t option
  val serialize : t -> bytes
  val serialize_all : t list -> bytes
end

module NodeAnnouncement : sig
  type t = {
    signature   : bytes;
    features    : bytes;
    timestamp   : Int32.t;
    node_id     : bytes;
    rgb_color   : bytes;
    alias       : bytes;
    addresses   : Address.t list;
  }

  val parse     : Bitstring.t -> t option
  val serialize : t -> bytes
end