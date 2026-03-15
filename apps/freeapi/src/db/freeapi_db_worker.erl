-module(freeapi_db_worker).
-behaviour(gen_server).
-behaviour(poolboy_worker).

-export([start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2]).

%% TODO: Implement poolboy worker wrapping a MongoDB connection
%%
%% start_link/1: Called by poolboy. Args = [{host, H}, {port, P}, {database, DB}]
%%
%% init/1:
%%   1. Extract host, port, database from Args
%%   2. Connect to MongoDB using mc_worker_api:connect/1 or mongodb driver API
%%   3. Store connection pid/ref in State
%%
%% handle_call/3: Implement calls for each DB operation:
%%   {find, Collection, Filter, Opts}
%%   {find_one, Collection, Filter, Opts}
%%   {insert, Collection, Doc, Opts}
%%   {update, Collection, Filter, Update, Opts}
%%   {delete, Collection, Filter, Opts}
%%   {count, Collection, Filter, Opts}
%%   {aggregate, Collection, Pipeline, Opts}
%%   {find_one_and_update, Collection, Filter, Update, Opts}
%%   {find_one_and_delete, Collection, Filter, Opts}
%%
%% terminate/2: Close MongoDB connection gracefully

start_link(Args) ->
    gen_server:start_link(?MODULE, Args, []).

init(_Args) ->
    %% TODO: connect to MongoDB
    {ok, #{}}.

handle_call(_Request, _From, State) ->
    %% TODO: implement DB operations
    {reply, {error, not_implemented}, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    %% TODO: close MongoDB connection
    ok.
