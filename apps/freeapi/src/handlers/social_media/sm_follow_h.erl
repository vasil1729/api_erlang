-module(sm_follow_h).
-behaviour(cowboy_handler).
-export([init/2]).

%% Handles 3 routes from API_SPEC 6.2:
%% TODO: [toggle]     POST /api/v1/social-media/follow/:toBeFollowedUserId - Auth, toggle follow/unfollow (200)
%% TODO: [followers]  GET  /api/v1/social-media/follow/list/followers/:username - Auth, paginated, include isFollowing (200)
%% TODO: [following]  GET  /api/v1/social-media/follow/list/following/:username - Auth, paginated (200)

init(Req0, State) ->
    %% TODO: implement
    {ok, Req0, State}.
