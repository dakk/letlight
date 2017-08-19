open Bitcoinml
open Bitstring
open Base
open Channel
open Discovery


type t = 
(* Base messages *)
| INIT of Init.t
| ERROR of Error.t
| PING of Ping.t
| PONG of Pong.t
(* Peer channel management messages *)
(*| OPEN_CHANNEL of OpenChannel.t
| ACCEPT_CHANNEL of AcceptChannel.t
| FUNDING_CREATED of FundingCreated.t
| FUNDING_SIGNED of FundingSigned.t
| FUNDING_LOCKED of FundingLocked.t
| SHUTDOWN of Shutdown.t
| CLOSING_SIGNED of ClosingSigned.t
| UPDATE_ADD_HTLC of UpdateAddHtlc.t
| UPDATE_FULLFILL_HTLC of UpdateFullfillHtlc.t
| UPDATE_FAIL_HTLC of UpdateFailHtlc.t
| UPDATE_FAIL_MALFORMED_HTLC of UpdateFailMalformedHtlc.t
| COMMITMENT_SIGNED of CommitmentSigned.t
| REVOKE_AND_ACK of RevokeAndAck.t
| UPDATE_FEE of UpdateFee.t*)
(* P2P Node and channel discovery messages *)
| NODE_ANNOUNCEMENT of NodeAnnouncement.t
(*| CHANNEL_ANNOUNCEMENT of ChannelAnnouncement.t;
| ANNOUNCEMENT_SIGNATURES of AnnouncementSignatures.t;
| CHANNEL_UPDATE of ChannelUpdate.t;
*)

val parse     : bytes -> t option
val serialize : t -> bytes