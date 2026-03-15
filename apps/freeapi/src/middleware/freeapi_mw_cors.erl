-module(freeapi_mw_cors).
-behaviour(cowboy_middleware).

-export([execute/2]).

%% TODO: Implement execute/2 (cowboy_middleware behaviour)
%% 1. Set CORS response headers on every request:
%%    - access-control-allow-origin: *
%%    - access-control-allow-methods: GET, POST, PUT, PATCH, DELETE, OPTIONS
%%    - access-control-allow-headers: content-type, authorization
%%    - access-control-allow-credentials: true
%% 2. If request method is OPTIONS (preflight), reply 204 and {stop, Req2}.
%% 3. Otherwise, return {ok, Req, Env} to continue pipeline.

execute(Req, Env) ->
    %% TODO: implement
    {ok, Req, Env}.
