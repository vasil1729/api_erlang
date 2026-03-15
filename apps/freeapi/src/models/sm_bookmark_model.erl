-module(sm_bookmark_model).
-export([toggle/2, find_all/2]).
%% TODO: Collection: <<"social_bookmarks">>
%% toggle(UserId, PostId) -> {ok, #{isBookmarked => boolean()}}
%% find_all(UserId, Opts) -> {[Bookmark], Total}  populate full post with author+counts
toggle(_UserId, _PostId) -> erlang:error(not_implemented).
find_all(_UserId, _Opts) -> erlang:error(not_implemented).
