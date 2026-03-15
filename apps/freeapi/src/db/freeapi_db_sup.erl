-module(freeapi_db_sup).
-behaviour(supervisor).

-export([start_link/0, init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% TODO: Implement init/1
%% 1. Read DB config from application env: db_host, db_port, db_name, db_pool_size, db_pool_overflow
%% 2. Configure poolboy child spec:
%%    - Pool name: {local, freeapi_db_pool}
%%    - Worker module: freeapi_db_worker
%%    - Size: db_pool_size (default 10)
%%    - Max overflow: db_pool_overflow (default 5)
%% 3. Worker args: [{host, Host}, {port, Port}, {database, DbName}]
%% 4. Return {ok, {{one_for_one, 5, 10}, [PoolChildSpec]}}

init([]) ->
    %% TODO: implement
    {ok, {{one_for_one, 5, 10}, []}}.
