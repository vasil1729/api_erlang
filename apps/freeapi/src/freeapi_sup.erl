-module(freeapi_sup).
-behaviour(supervisor).

-export([start_link/0, init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% TODO: Implement init/1 with one_for_one strategy
%% Child specs (in order):
%% 1. freeapi_db_sup     - Database pool supervisor
%% 2. freeapi_json_cache  - gen_server that loads static JSON data into ETS tables
%% 3. freeapi_chat_registry - gen_server that tracks WebSocket pids per chat room
%%
%% Restart intensity: 5 restarts in 10 seconds

init([]) ->
    ChildSpecs = [
        %% {freeapi_db_sup, {freeapi_db_sup, start_link, []}, permanent, 5000, supervisor, [freeapi_db_sup]},
        %% {freeapi_json_cache, {freeapi_json_cache, start_link, []}, permanent, 5000, worker, [freeapi_json_cache]},
        %% {freeapi_chat_registry, {freeapi_chat_registry, start_link, []}, permanent, 5000, worker, [freeapi_chat_registry]}
    ],
    {ok, {{one_for_one, 5, 10}, ChildSpecs}}.
