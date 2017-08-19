open Bitcoinml;;
open Bitstring;;


module Address = struct
  type atype = NONE | IPV4 | IPV6 | TORV2 | TORV3;;

  type t = {
    address_type: atype;
    address     : bytes;
    port        : int;
  };;
  
  let parse data =
    match%bitstring data with 
    | {|
      adtype : 8 : int;
      rest   : -1 : bitstring
    |} -> 
      match adtype with
      | 0 -> (rest, Some ({ address_type=NONE; address=""; port=0x0 }))
      | 1 -> (match%bitstring rest with 
        | {| address : 4 * 8 : string; port : 2 * 8 : bigendian; rest : -1 : bitstring |} -> (rest, Some ({ address_type=IPV4; address=address; port=port}))
        | {| _ |} -> (data, None))
      | 2 -> (match%bitstring rest with 
        | {| address : 16 * 8 : string; port : 2 * 8 : bigendian; rest : -1 : bitstring |} -> (rest, Some ({ address_type=IPV6; address=address; port=port}))
        | {| _ |} -> (data, None))
      | 3 -> (match%bitstring rest with 
        | {| address : 10 * 8 : string; port : 2 * 8 : bigendian; rest : -1 : bitstring |} -> (rest, Some ({ address_type=TORV2; address=address; port=port}))
        | {| _ |} -> (data, None))
      | 4 -> (match%bitstring rest with 
        | {| address : 35 * 8 : string; port : 2 * 8 : bigendian; rest : -1 : bitstring |} -> (rest, Some ({ address_type=TORV3; address=address; port=port}))
        | {| _ |} -> (data, None))
      | _ -> (data, None)
  ;;      

  let rec parse_all data = 
    match parse data with
    | rest, None -> []
    | rest, Some (a) -> a :: parse_all rest
  ;;

  let serialize addr = 
    match addr.address_type with
    | NONE -> string_of_bitstring [%bitstring {|
      0 : 1 * 8 : bigendian
    |}]
    | IPV4 -> string_of_bitstring [%bitstring {|
      1 : 1 * 8 : bigendian;
      addr.address : 4 * 8 : string;
      addr.port : 2 * 8 : bigendian
    |}]
    | IPV6 -> string_of_bitstring [%bitstring {|
      2 : 1 * 8 : bigendian;
      addr.address : 16 * 8 : string;
      addr.port : 2 * 8 : bigendian
    |}]
    | TORV2 -> string_of_bitstring [%bitstring {|
      3 : 1 * 8 : bigendian;
      addr.address : 10 * 8 : string;
      addr.port : 2 * 8 : bigendian
    |}]
    | TORV3 -> string_of_bitstring [%bitstring {|
      4 : 1 * 8 : bigendian;
      addr.address : 35 * 8 : string;
      addr.port : 2 * 8 : bigendian
    |}]
  ;;

  let rec serialize_all addrs = match addrs with
  | [] -> ""
  | x :: xl -> (serialize x) ^ (serialize_all xl)
  ;;
end

module NodeAnnouncement = struct
  type t = {
    signature   : bytes;
    features    : bytes;
    timestamp   : Int32.t;
    node_id     : bytes;
    rgb_color   : bytes;
    alias       : bytes;
    addresses   : Address.t list;
  };;

  let parse data = match%bitstring data with
  | {| 
    signature : 64 * 8 : string;
    flen : 2 * 8 : bigendian;
    features : flen * 8 : string;
    timestamp : 4 * 8 : bigendian;
    node_id : 33 * 8 : string;
    rgb_color : 3 * 8 : string;
    alias : 32 * 8 : string;
    alen : 2 * 8 : bigendian;
    rest : alen * 8 : bitstring
    |} -> Some ({
      signature= signature;
      features= features;
      timestamp= timestamp;
      node_id= node_id;
      rgb_color= rgb_color;
      alias= alias;
      addresses= Address.parse_all rest
    })
  | {| _ |} -> None
  ;;

  let serialize msg = 
    let addr = Address.serialize_all msg.addresses in
    string_of_bitstring [%bitstring {|
      msg.signature : 64 * 8 : string;
      Bytes.length msg.features : 2 * 8 : bigendian;
      msg.features : (Bytes.length msg.features) * 8 : string;
      msg.timestamp : 4 * 8 : bigendian;
      msg.node_id : 33 * 8 : string;
      msg.rgb_color : 3 * 8 : string;
      msg.alias : 32 * 8 : string;
      Bytes.length addr : 2 * 8 : bigendian;
      addr : (Bytes.length addr) * 8 : string
    |}]
  ;;
end