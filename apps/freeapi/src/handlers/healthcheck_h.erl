-module(healthcheck_h).
-behaviour(cowboy_handler).
-export([init/2]).

%% TODO: GET /api/v1/healthcheck (API_SPEC 1.1)
%% No auth. Return 200 with {"statusCode": 200, "message": "OK", "success": true, "data": null}
init(Req0, State) ->
    %% TODO: implement
    {ok, Req0, State}.
