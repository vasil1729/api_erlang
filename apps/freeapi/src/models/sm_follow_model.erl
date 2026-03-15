-module(sm_follow_model).
-export([toggle/2, get_followers/3, get_following/3]).
%% TODO: Collection: <<"social_follows">>
%% toggle(FollowerId, FolloweeId) -> {ok, #{following => boolean()}}
%% get_followers(CurrentUserId, Username, Opts) -> {[User], Total}  include isFollowing relative to CurrentUserId
%% get_following(CurrentUserId, Username, Opts) -> {[User], Total}
toggle(_FollowerId, _FolloweeId) -> erlang:error(not_implemented).
get_followers(_CurrentUserId, _Username, _Opts) -> erlang:error(not_implemented).
get_following(_CurrentUserId, _Username, _Opts) -> erlang:error(not_implemented).
