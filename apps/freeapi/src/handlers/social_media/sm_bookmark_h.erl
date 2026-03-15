-module(sm_bookmark_h).
-behaviour(cowboy_handler).
-export([init/2]).

%% Handles 2 routes from API_SPEC 6.5:
%% TODO: [list]   GET  /api/v1/social-media/bookmarks - Auth, paginated, populate full post (200)
%% TODO: [toggle] POST /api/v1/social-media/bookmarks/:postId - Auth, toggle bookmark (200)

init(Req0, State) ->
    %% TODO: implement
    {ok, Req0, State}.
