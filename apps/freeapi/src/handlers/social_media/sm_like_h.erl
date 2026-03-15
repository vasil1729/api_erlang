-module(sm_like_h).
-behaviour(cowboy_handler).
-export([init/2]).

%% Handles 2 routes from API_SPEC 6.4:
%% TODO: [like_post]    POST /api/v1/social-media/like/post/:postId - Auth, toggle like on post (200)
%% TODO: [like_comment] POST /api/v1/social-media/like/comment/:commentId - Auth, toggle like on comment (200)

init(Req0, State) ->
    %% TODO: implement
    {ok, Req0, State}.
