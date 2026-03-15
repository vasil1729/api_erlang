-module(sm_post_model).
-export([create/2, find_all/2, find_by_id/2, update/3, delete/2,
         find_my/2, find_by_username/3, find_by_tag/3, remove_image/3]).
%% TODO: Collection: <<"social_posts">>
%% All list queries include: author(populated), likesCount, commentsCount, isLiked, isBookmarked relative to CurrentUserId
%% create(UserId, Data) -> {ok, Post}  Data has content, tags, images
%% find_all(CurrentUserId, Opts) -> {[Post], Total}
%% find_by_id(CurrentUserId, PostId) -> {ok, Post} | not_found
%% update(UserId, PostId, Updates) -> {ok, Post}  must be author
%% delete(UserId, PostId) -> ok  cascade: comments, likes, bookmarks, image files
%% find_my(UserId, Opts) -> {[Post], Total}
%% find_by_username(CurrentUserId, Username, Opts) -> {[Post], Total}
%% find_by_tag(CurrentUserId, Tag, Opts) -> {[Post], Total}
%% remove_image(UserId, PostId, ImageId) -> {ok, Post}  delete file
create(_UserId, _Data) -> erlang:error(not_implemented).
find_all(_CurrentUserId, _Opts) -> erlang:error(not_implemented).
find_by_id(_CurrentUserId, _PostId) -> erlang:error(not_implemented).
update(_UserId, _PostId, _Updates) -> erlang:error(not_implemented).
delete(_UserId, _PostId) -> erlang:error(not_implemented).
find_my(_UserId, _Opts) -> erlang:error(not_implemented).
find_by_username(_CurrentUserId, _Username, _Opts) -> erlang:error(not_implemented).
find_by_tag(_CurrentUserId, _Tag, _Opts) -> erlang:error(not_implemented).
remove_image(_UserId, _PostId, _ImageId) -> erlang:error(not_implemented).
