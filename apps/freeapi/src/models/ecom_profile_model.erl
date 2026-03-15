-module(ecom_profile_model).
-export([get_or_create/1, update/2]).
%% TODO: Collection: <<"ecommerce_profiles">>
%% get_or_create(UserId) -> {ok, Profile}  create with defaults if not exists
%% update(UserId, Updates) -> {ok, Profile}
get_or_create(_UserId) -> erlang:error(not_implemented).
update(_UserId, _Updates) -> erlang:error(not_implemented).
