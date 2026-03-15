-module(sm_like_model).
-export([toggle_post_like/2, toggle_comment_like/2]).
%% TODO: Collection: <<"social_likes">>
%% toggle_post_like(UserId, PostId) -> {ok, #{isLiked => boolean()}}
%% toggle_comment_like(UserId, CommentId) -> {ok, #{isLiked => boolean()}}
toggle_post_like(_UserId, _PostId) -> erlang:error(not_implemented).
toggle_comment_like(_UserId, _CommentId) -> erlang:error(not_implemented).
