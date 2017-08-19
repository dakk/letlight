open Bitcoinml;;
open Bitstring;;

module Init = struct
  type t = {
    global_features : bytes;
    local_features  : bytes;
  }

  let parse data = match%bitstring data with
  | {| 
    gflen : 2 * 8 : bigendian;
    globalfeatures : gflen * 8 : string;
    lflen : 2 * 8 : bigendian;
    localfeatures : lflen * 8 : string 
    |} -> Some ({
      global_features= globalfeatures;
      local_features= localfeatures
    })
  | {| _ |} -> None
  ;;

  let serialize msg = string_of_bitstring [%bitstring {|
    Bytes.length msg.global_features : 2 * 8 : bigendian;
    msg.global_features : (Bytes.length msg.global_features) * 8 : string;
    Bytes.length msg.local_features : 2 * 8 : bigendian;
    msg.local_features : (Bytes.length msg.local_features) * 8 : string
  |}]
  ;;
end


module Error = struct
  type t = {
    channel_id   : Hash.t;
    data         : bytes;
  }

  let parse data = match%bitstring data with
  | {| 
    channel_id : 32 * 8 : string;
    len : 2 * 8 : bigendian;
    data : len * 8 : string 
    |} -> Some ({
      channel_id= Hash.of_bin channel_id;
      data= data;
    })
  | {| _ |} -> None
  ;;

  let serialize msg = string_of_bitstring [%bitstring {|
    Hash.to_bin msg.channel_id : 32 * 8 : string;
    Bytes.length msg.data : 2 * 8 : bigendian;
    msg.data : (Bytes.length msg.data) * 8 : string
  |}];;
end


module Ping = struct
  type t = {
    pong_len  : int;
    data      : bytes;
  }

  let parse data = match%bitstring data with
  | {| 
    pong_len : 2 * 8 : bigendian;
    len : 2 * 8 : bigendian;
    data : len * 8 : string 
    |} -> Some ({
      pong_len= pong_len;
      data= data;
    })
  | {| _ |} -> None
  ;;

  let serialize msg = string_of_bitstring [%bitstring {|
    msg.pong_len : 2 * 8 : bigendian;
    Bytes.length msg.data : 2 * 8 : bigendian;
    msg.data : (Bytes.length msg.data) * 8 : string
  |}];;
end

module Pong = struct
  type t = {
    data : bytes;
  }

  let parse data = match%bitstring data with
  | {| 
    len : 2 * 8 : bigendian;
    data : len * 8 : string 
    |} -> Some ({
      data= data;
    })
  | {| _ |} -> None
  ;;

  let serialize msg = string_of_bitstring [%bitstring {|
    Bytes.length msg.data : 2 * 8 : bigendian;
    msg.data : (Bytes.length msg.data) * 8 : string
  |}];;
end
