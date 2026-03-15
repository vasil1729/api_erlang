-module(cart_h).
-behaviour(cowboy_handler).
-export([init/2]).

%% Handles 4 routes from API_SPEC 5.5:
%% TODO: [get_cart]    GET    /api/v1/ecommerce/cart - Auth, get/create cart, populate items+coupon, calc totals (200)
%% TODO: [clear]       DELETE /api/v1/ecommerce/cart/clear - Auth, remove all items+coupon, reset totals (200)
%% TODO: [add_item]    POST   /api/v1/ecommerce/cart/item/:productId - Auth, body: quantity(opt), add/increment (200)
%% TODO: [remove_item] DELETE /api/v1/ecommerce/cart/item/:productId - Auth, remove item, recalculate (200)

init(Req0, State) ->
    %% TODO: implement
    {ok, Req0, State}.
