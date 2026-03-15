-module(healthcheck_h).
-behaviour(cowboy_handler).
-export([init/2]).

%% GET /api/v1/healthcheck (API_SPEC 1.1)
%% No auth. Return 200 with {"statusCode": 200, "message": "OK", "success": true, "data": null}
init(Req0, State) ->
    Req = response:success(Req0, 200, null),
    {ok, Req, State}.
