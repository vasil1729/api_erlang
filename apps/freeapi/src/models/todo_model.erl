-module(todo_model).

-export([create/2, find_all/2, find_by_id/2, update/3, delete/2, toggle_status/2]).

%% TODO: Collection: <<"todos">>
%%
%% create(UserId, #{title, description}) -> {ok, Todo}
%%   Set owner=UserId, isComplete=false
%%
%% find_all(UserId, Opts) -> {[Todo], TotalCount}
%%   Opts: page, limit, complete (bool filter), query (search in title)
%%   Filter by owner=UserId
%%
%% find_by_id(UserId, TodoId) -> {ok, Todo} | not_found
%%   Must match both _id and owner
%%
%% update(UserId, TodoId, Updates) -> {ok, Todo} | not_found
%%   Only update title, description. Must be owner.
%%
%% delete(UserId, TodoId) -> ok | not_found
%%
%% toggle_status(UserId, TodoId) -> {ok, Todo} | not_found
%%   Flip isComplete: true->false, false->true

create(_UserId, _Data) -> erlang:error(not_implemented).
find_all(_UserId, _Opts) -> erlang:error(not_implemented).
find_by_id(_UserId, _TodoId) -> erlang:error(not_implemented).
update(_UserId, _TodoId, _Updates) -> erlang:error(not_implemented).
delete(_UserId, _TodoId) -> erlang:error(not_implemented).
toggle_status(_UserId, _TodoId) -> erlang:error(not_implemented).
