-module(quote_h).
-behaviour(cowboy_handler).
-export([init/2]).

%% Handles 3 routes from API_SPEC 2.5:
%% TODO: [list]    GET /api/v1/public/quotes - paginated, query search
%% TODO: [get_one] GET /api/v1/public/quotes/:quoteId - single or 404
%% TODO: [random]  GET /api/v1/public/quotes/quote/random

init(Req0, State) ->
    %% TODO: implement
    {ok, Req0, State}.
