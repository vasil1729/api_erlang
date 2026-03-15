-module(cat_h).
-behaviour(cowboy_handler).
-export([init/2]).

%% Handles 3 routes from API_SPEC 2.8:
%% TODO: [list]    GET /api/v1/public/cats - paginated, query search
%% TODO: [get_one] GET /api/v1/public/cats/:catId - single or 404
%% TODO: [random]  GET /api/v1/public/cats/cat/random

init(Req0, State) ->
    %% TODO: implement
    {ok, Req0, State}.
