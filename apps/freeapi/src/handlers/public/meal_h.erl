-module(meal_h).
-behaviour(cowboy_handler).
-export([init/2]).

%% Handles 3 routes from API_SPEC 2.6:
%% TODO: [list]    GET /api/v1/public/meals - paginated, query search
%% TODO: [get_one] GET /api/v1/public/meals/:mealId - single or 404
%% TODO: [random]  GET /api/v1/public/meals/meal/random

init(Req0, State) ->
    %% TODO: implement
    {ok, Req0, State}.
