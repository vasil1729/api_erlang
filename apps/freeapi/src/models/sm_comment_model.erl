-module(sm_comment_model).
-export([create/3, find_by_post/3, update/3, delete/2]).
%% TODO: Collection: <<"social_comments">>
%% create(UserId, PostId, #{content}) -> {ok, Comment}
%% find_by_post(CurrentUserId, PostId, Opts) -> {[Comment], Total}  include author, likesCount, isLiked
%% update(UserId, CommentId, #{content}) -> {ok, Comment}  must be author
%% delete(UserId, CommentId) -> ok  cascade delete likes on this comment
create(_UserId, _PostId, _Data) -> erlang:error(not_implemented).
find_by_post(_CurrentUserId, _PostId, _Opts) -> erlang:error(not_implemented).
update(_UserId, _CommentId, _Data) -> erlang:error(not_implemented).
delete(_UserId, _CommentId) -> erlang:error(not_implemented).
