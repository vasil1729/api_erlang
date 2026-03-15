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
    %% TODO: implement
    {ok, {{one_for_one, 5, 10}, []}}.
