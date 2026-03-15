-module(crypto_util).

-export([sha256/1, random_token/0, random_token/1, hmac_sha256/2]).

%% TODO: Implement SHA256 hashing
%% sha256(Binary) -> HexString
%% Used for hashing email verification tokens and forgot-password tokens
sha256(_Data) -> erlang:error(not_implemented).

%% TODO: Implement random token generation
%% random_token() -> Binary (32-byte random hex string)
%% random_token(Length) -> Binary (N-byte random hex string)
random_token() -> erlang:error(not_implemented).
random_token(_Length) -> erlang:error(not_implemented).

%% TODO: hmac_sha256(Key, Data) -> Binary
%% Used for Razorpay signature verification
hmac_sha256(_Key, _Data) -> erlang:error(not_implemented).
