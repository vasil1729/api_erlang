-module(statuscode_h).
-behaviour(cowboy_handler).
-export([init/2]).

%% Handles 2 routes from API_SPEC 8.2:
%% TODO: [list]    GET /api/v1/kitchen-sink/status-codes - return all HTTP status codes list (200)
%% TODO: [get_one] GET /api/v1/kitchen-sink/status-codes/:statusCode - reply with that status code (100-599, else 400)

init(Req0, State) ->
    %% TODO: implement
    {ok, Req0, State}.
