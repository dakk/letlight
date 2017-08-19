open Bitcoinml
open Bitstring

(*module OpenChannel : sig
  type t = {
    chain_hash                    : Hash.t;
    temp_channel_id               : Hash.t;
    funding_satoshis              : int;
    push_msat                     : int;
    dust_limit_satoshis           : int;
    max_htlc_value_in_flight_msat : int;
    channel_reserve_satoshis      : int;
    htlc_minimum_msat             : int;
    feerate_per_kw                : int;
    to_self_delay                 : int;
    max_accepted_htlcs            : int;
    funding_pubkey                : string;
    revocation_basepoint          : string;
    payment_basepoint             : string;
    delayed_payment_basepoint     : string;
    first_per_commitment_point    : string;
    channel_flags                 : int;
  }
end*)