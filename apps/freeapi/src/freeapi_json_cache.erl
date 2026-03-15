-module(freeapi_json_cache).
-behaviour(gen_server).

-export([start_link/0]).
-export([get_page/4, get_by_id/2, get_random/1, search/3]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% TODO: Implement init/1
%% 1. Load all JSON data files from priv/data/ directory:
%%    randomusers.json, randomproducts.json, randomjokes.json,
%%    books.json, quotes.json, meals.json, dogs.json, cats.json, stocks.json
%% 2. For each file, create a named ETS table (set, read_concurrency=true)
%% 3. Parse JSON with jiffy:decode/2 [return_maps]
%% 4. Insert each item as {Id, ItemMap} into the ETS table
%% 5. Store ordered ID list as {all_ids, [Id1, Id2, ...]} for pagination

init([]) ->
    %% TODO: implement
    {ok, #{}}.

%% TODO: get_page(Resource, Page, Limit, QueryOpts) -> {Items, TotalCount}
%% Resource :: atom() (e.g., randomusers, books, etc.)
%% QueryOpts :: map() with optional keys: query (search text), inc (fields filter)
%% Use ETS lookup for fast reads
get_page(_Resource, _Page, _Limit, _Opts) -> erlang:error(not_implemented).

%% TODO: get_by_id(Resource, Id) -> {ok, Item} | not_found
get_by_id(_Resource, _Id) -> erlang:error(not_implemented).

%% TODO: get_random(Resource) -> Item
%% Pick random ID from all_ids list, lookup in ETS
get_random(_Resource) -> erlang:error(not_implemented).

%% TODO: search(Resource, Field, Query) -> [Item]
%% Full-text search within a specific field across all items
search(_Resource, _Field, _Query) -> erlang:error(not_implemented).

handle_call(_Request, _From, State) -> {reply, ok, State}.
handle_cast(_Msg, State) -> {noreply, State}.
handle_info(_Info, State) -> {noreply, State}.
