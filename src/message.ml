open Bitstring;;
open Bitcoinml;;

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


type t = 
| INIT of Init.t
| ERROR of Error.t
| PING of Ping.t
| PONG of Pong.t
;;


let serialize msg = 
  let serialize' typecode payload =
    string_of_bitstring [%bitstring {|
      typecode	: 2*8 	: bigendian;
      payload   : Bytes.length (payload) : string
    |}]
  in
  match msg with
  | INIT (d) -> serialize' 16 @@ Init.serialize d
  | ERROR (d) -> serialize' 17 @@ Error.serialize d
  | PING (d) -> serialize' 18 @@ Ping.serialize d
  | PONG (d) -> serialize' 19 @@ Pong.serialize d
;;


let parse data = 
  match%bitstring Bitstring.bitstring_of_string data with
  | {| typecode  : 2 * 8 : bigendian; payload : -1 : bitstring |} -> (
    match typecode with
    | 16 -> (match Init.parse payload with Some (init) -> Some (INIT (init)) | None -> None)
    | 17 -> (match Error.parse payload with Some (error) -> Some (ERROR (error)) | None -> None)
    | 18 -> (match Ping.parse payload with Some (ping) -> Some (PING (ping)) | None -> None)
    | 19 -> (match Pong.parse payload with Some (pong) -> Some (PONG (pong)) | None -> None)
    | _ -> None)
  | {|_|} -> None
;;