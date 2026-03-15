-module(randomjoke_h).
-behaviour(cowboy_handler).
-export([init/2]).

%% Handles 3 routes from API_SPEC 2.3:
%% TODO: [list]    GET /api/v1/public/randomjokes - paginated, query search in content, inc fields
%% TODO: [get_one] GET /api/v1/public/randomjokes/:jokeId - single or 404
%% TODO: [random]  GET /api/v1/public/randomjokes/joke/random - random joke

init(Req0, State) ->
    %% TODO: implement
    {ok, Req0, State}.
