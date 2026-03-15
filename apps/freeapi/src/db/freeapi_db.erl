-module(freeapi_db).

-export([find/3, find_one/3, insert/3, update/4, delete/3, count/3,
         aggregate/3, find_one_and_update/4, find_one_and_delete/3]).

%% TODO: Implement MongoDB query helpers
%% All functions checkout a worker from poolboy (freeapi_db_pool),
%% execute the query via freeapi_db_worker, and return the result.
%%
%% Use: poolboy:transaction(freeapi_db_pool, fun(Worker) -> ... end)

%% TODO: find(Collection, Filter, Opts) -> {ok, [Doc]} | {error, Reason}
%% Collection :: binary() e.g. <<"users">>
%% Filter :: map() e.g. #{<<"owner">> => UserId}
%% Opts :: map() with optional keys: skip, limit, sort, projection
find(_Collection, _Filter, _Opts) ->
    erlang:error(not_implemented).

%% TODO: find_one(Collection, Filter, Opts) -> {ok, Doc} | not_found | {error, Reason}
find_one(_Collection, _Filter, _Opts) ->
    erlang:error(not_implemented).

%% TODO: insert(Collection, Doc, Opts) -> {ok, InsertedDoc} | {error, Reason}
%% Auto-add createdAt and updatedAt timestamps
insert(_Collection, _Doc, _Opts) ->
    erlang:error(not_implemented).

%% TODO: update(Collection, Filter, Update, Opts) -> {ok, UpdatedDoc} | {error, Reason}
%% Auto-update updatedAt timestamp
update(_Collection, _Filter, _Update, _Opts) ->
    erlang:error(not_implemented).

%% TODO: delete(Collection, Filter, Opts) -> {ok, DeleteCount} | {error, Reason}
delete(_Collection, _Filter, _Opts) ->
    erlang:error(not_implemented).

%% TODO: count(Collection, Filter, Opts) -> {ok, Count} | {error, Reason}
count(_Collection, _Filter, _Opts) ->
    erlang:error(not_implemented).

%% TODO: aggregate(Collection, Pipeline, Opts) -> {ok, [Doc]} | {error, Reason}
%% For complex queries (e.g., social media posts with likes/comments counts)
aggregate(_Collection, _Pipeline, _Opts) ->
    erlang:error(not_implemented).

%% TODO: find_one_and_update(Collection, Filter, Update, Opts) -> {ok, Doc} | not_found
%% Return the document after update (for toggle operations)
find_one_and_update(_Collection, _Filter, _Update, _Opts) ->
    erlang:error(not_implemented).

%% TODO: find_one_and_delete(Collection, Filter, Opts) -> {ok, Doc} | not_found
find_one_and_delete(_Collection, _Filter, _Opts) ->
    erlang:error(not_implemented).
