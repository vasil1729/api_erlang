-module(address_h).
-behaviour(cowboy_handler).
-export([init/2]).

%% Handles 5 routes from API_SPEC 5.2:
%% TODO: [list]    GET    /api/v1/ecommerce/addresses - Auth, paginated, owner filter (200)
%% TODO: [create]  POST   /api/v1/ecommerce/addresses - Auth, body: addressLine1,city,state,country,pincode (201)
%% TODO: [get_one] GET    /api/v1/ecommerce/addresses/:addressId - Auth, must be owner (200/404)
%% TODO: [update]  PATCH  /api/v1/ecommerce/addresses/:addressId - Auth, owner only (200)
%% TODO: [delete]  DELETE /api/v1/ecommerce/addresses/:addressId - Auth, owner only (200)

init(Req0, State) ->
    %% TODO: implement
    {ok, Req0, State}.
