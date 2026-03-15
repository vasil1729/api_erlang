-module(ecom_profile_h).
-behaviour(cowboy_handler).
-export([init/2]).

%% Handles 3 routes from API_SPEC 5.4:
%% TODO: [get_profile]  GET   /api/v1/ecommerce/profile - Auth, return user's ecom profile (200)
%% TODO: [update]       PATCH /api/v1/ecommerce/profile - Auth, body: firstName,lastName,countryCode,phoneNumber (200)
%% TODO: [my_orders]    GET   /api/v1/ecommerce/profile/my-orders - Auth, paginated orders by customer (200)

init(Req0, State) ->
    %% TODO: implement
    {ok, Req0, State}.
