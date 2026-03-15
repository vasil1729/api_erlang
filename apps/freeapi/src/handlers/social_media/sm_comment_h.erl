-module(sm_comment_h).
-behaviour(cowboy_handler).
-export([init/2]).

%% Handles 4 routes from API_SPEC 6.6:
%% TODO: [list]   GET    /api/v1/social-media/comments/post/:postId - Auth, paginated, include author,likesCount,isLiked (200)
%% TODO: [create] POST   /api/v1/social-media/comments/post/:postId - Auth, body: content (201)
%% TODO: [update] PATCH  /api/v1/social-media/comments/:commentId - Auth, author only, body: content (200)
%% TODO: [delete] DELETE /api/v1/social-media/comments/:commentId - Auth, author only, cascade delete likes (200)

init(Req0, State) ->
    %% TODO: implement
    {ok, Req0, State}.
