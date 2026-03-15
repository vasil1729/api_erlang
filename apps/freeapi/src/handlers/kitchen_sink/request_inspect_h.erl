-module(request_inspect_h).
-behaviour(cowboy_handler).
-export([init/2]).

%% Handles 5 routes from API_SPEC 8.3:
%% TODO: [headers]        GET /api/v1/kitchen-sink/request/headers - return all request headers (200)
%% TODO: [ip]             GET /api/v1/kitchen-sink/request/ip - return client IP (200)
%% TODO: [user_agent]     GET /api/v1/kitchen-sink/request/user-agent - return user-agent header (200)
%% TODO: [path_variable]  GET /api/v1/kitchen-sink/request/path-variable/:pathVariable - echo path var (200)
%% TODO: [query_params]   GET /api/v1/kitchen-sink/request/query-parameter - echo all query params (200)

init(Req0, State) ->
    %% TODO: implement
    {ok, Req0, State}.
