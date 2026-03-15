-module(randomproduct_h).
-behaviour(cowboy_handler).
-export([init/2]).

%% Handles 3 routes from API_SPEC 2.2:
%%
%% TODO: [list]   GET /api/v1/public/randomproducts
%%   No auth. Query: page, limit, query (filter by category), inc (fields filter).
%%   Return paginated Product objects from ETS.
%%
%% TODO: [get_one] GET /api/v1/public/randomproducts/:productId
%%   No auth. Return single Product or 404.
%%
%% TODO: [random] GET /api/v1/public/randomproducts/product/random
%%   No auth. Return single random Product.

init(Req0, State) ->
    %% TODO: implement
    {ok, Req0, State}.
