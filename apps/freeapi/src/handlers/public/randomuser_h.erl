-module(randomuser_h).
-behaviour(cowboy_handler).
-export([init/2]).

%% Handles 3 routes from API_SPEC 2.1:
%%
%% TODO: [list]   GET /api/v1/public/randomusers
%%   No auth. Query params: page, limit.
%%   Read from freeapi_json_cache ETS (randomusers table).
%%   Return paginated array of User objects.
%%
%% TODO: [get_one] GET /api/v1/public/randomusers/:userId
%%   No auth. Path param: userId (integer).
%%   Lookup by ID in ETS. Return single User object or 404.
%%
%% TODO: [random] GET /api/v1/public/randomusers/user/random
%%   No auth. Return single random User object from ETS.

init(Req0, State) ->
    %% TODO: pattern match on State to dispatch [list], [get_one], [random]
    {ok, Req0, State}.
