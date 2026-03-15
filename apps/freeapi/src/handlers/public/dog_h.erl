-module(dog_h).
-behaviour(cowboy_handler).
-export([init/2]).

%% Handles 3 routes from API_SPEC 2.7:
%% TODO: [list]    GET /api/v1/public/dogs - paginated, query search
%% TODO: [get_one] GET /api/v1/public/dogs/:dogId - single or 404
%% TODO: [random]  GET /api/v1/public/dogs/dog/random

init(Req0, State) ->
    %% TODO: implement
    {ok, Req0, State}.
