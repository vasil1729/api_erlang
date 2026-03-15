-module(stock_h).
-behaviour(cowboy_handler).
-export([init/2]).

%% Handles 3 routes from API_SPEC 2.9:
%% TODO: [list]    GET /api/v1/public/stocks - paginated
%% TODO: [get_one] GET /api/v1/public/stocks/:stockSymbol - lookup by symbol string, or 404
%% TODO: [random]  GET /api/v1/public/stocks/stock/random

init(Req0, State) ->
    %% TODO: implement
    {ok, Req0, State}.
