


let serialize msg = 
  let serialize' typecode payload =
    [%bitstring {|
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
  | {| typecode  : 2 * 8 : bigendian; payload : -1 : bitstring |} ->
    match typecode with
    | 16 -> Init.parse rest
    | 17 -> Error.parse rest
    | 18 -> Ping.parse rest
    | 19 -> Pong.parse rest
    | _ -> INVALID (data)
  | _ -> INVALID (data)
;;