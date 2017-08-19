open Bitstring;;
open Bitcoinml;;
open Base;;
open Channel;;
open Discovery;;


type t = 
| INIT of Init.t
| ERROR of Error.t
| PING of Ping.t
| PONG of Pong.t
| NODE_ANNOUNCEMENT of NodeAnnouncement.t
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
  | NODE_ANNOUNCEMENT (d) -> serialize' 257 @@ NodeAnnouncement.serialize d
;;


let parse data = 
  match%bitstring Bitstring.bitstring_of_string data with
  | {| typecode  : 2 * 8 : bigendian; payload : -1 : bitstring |} -> (
    match typecode with
    | 16 -> (match Init.parse payload with Some (init) -> Some (INIT (init)) | None -> None)
    | 17 -> (match Error.parse payload with Some (error) -> Some (ERROR (error)) | None -> None)
    | 18 -> (match Ping.parse payload with Some (ping) -> Some (PING (ping)) | None -> None)
    | 19 -> (match Pong.parse payload with Some (pong) -> Some (PONG (pong)) | None -> None)
    | 257 -> (match NodeAnnouncement.parse payload with Some (node_announcement) -> Some (NODE_ANNOUNCEMENT (node_announcement)) | None -> None)
    | _ -> None)
  | {|_|} -> None
;;