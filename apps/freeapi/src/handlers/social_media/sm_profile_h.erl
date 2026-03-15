-module(sm_profile_h).
-behaviour(cowboy_handler).
-export([init/2]).

%% Handles 4 routes from API_SPEC 6.1:
%% TODO: [by_username]    GET   /api/v1/social-media/profile/u/:username - Auth, include followersCount,followingCount,isFollowing (200)
%% TODO: [get_my]         GET   /api/v1/social-media/profile - Auth, current user's profile (200)
%% TODO: [update]         PATCH /api/v1/social-media/profile - Auth, body: firstName,lastName,bio,dob,location,etc (200)
%% TODO: [update_cover]   PATCH /api/v1/social-media/profile/cover-image - Auth, multipart: coverImage file (200)

init(Req0, State) ->
    %% TODO: implement
    {ok, Req0, State}.
