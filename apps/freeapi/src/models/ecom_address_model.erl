-module(ecom_address_model).
-export([create/2, find_all/2, find_by_id/2, update/3, delete/2]).
%% TODO: Collection: <<"addresses">>
%% create(UserId, Data) -> {ok, Address}
%% find_all(UserId, Opts) -> {[Address], Total}  filter by owner
%% find_by_id(UserId, AddressId) -> {ok, Address} | not_found  must be owner
%% update(UserId, AddressId, Updates) -> {ok, Address}
%% delete(UserId, AddressId) -> ok
create(_UserId, _Data) -> erlang:error(not_implemented).
find_all(_UserId, _Opts) -> erlang:error(not_implemented).
find_by_id(_UserId, _Id) -> erlang:error(not_implemented).
update(_UserId, _Id, _Updates) -> erlang:error(not_implemented).
delete(_UserId, _Id) -> erlang:error(not_implemented).
