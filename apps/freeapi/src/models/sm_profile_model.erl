-module(sm_profile_model).
-export([get_or_create/1, get_by_username/2, update/2, update_cover_image/2]).
%% TODO: Collection: <<"social_profiles">>
%% get_or_create(UserId) -> {ok, Profile}
%% get_by_username(Username, CurrentUserId) -> {ok, Profile}  include followersCount, followingCount, isFollowing
%% update(UserId, Updates) -> {ok, Profile}
%% update_cover_image(UserId, ImageMap) -> {ok, Profile}
get_or_create(_UserId) -> erlang:error(not_implemented).
get_by_username(_Username, _CurrentUserId) -> erlang:error(not_implemented).
update(_UserId, _Updates) -> erlang:error(not_implemented).
update_cover_image(_UserId, _Image) -> erlang:error(not_implemented).
