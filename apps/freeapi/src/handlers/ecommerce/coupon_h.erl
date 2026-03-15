-module(coupon_h).
-behaviour(cowboy_handler).
-export([init/2]).

%% Handles 9 routes from API_SPEC 5.7:
%% TODO: [apply_coupon]     POST   /api/v1/ecommerce/coupons/c/apply - Auth, body: couponCode, validate+apply to cart (200)
%% TODO: [remove_coupon]    POST   /api/v1/ecommerce/coupons/c/remove - Auth, body: couponCode, remove from cart (200)
%% TODO: [customer_avail]   GET    /api/v1/ecommerce/coupons/customer/available - Auth, paginated active non-expired (200)
%% TODO: [list]             GET    /api/v1/ecommerce/coupons - Admin, paginated all coupons (200)
%% TODO: [create]           POST   /api/v1/ecommerce/coupons - Admin, body: name,couponCode,discountValue,etc (201)
%% TODO: [get_one]          GET    /api/v1/ecommerce/coupons/:couponId - Admin (200/404)
%% TODO: [update]           PATCH  /api/v1/ecommerce/coupons/:couponId - Admin, partial update (200)
%% TODO: [delete]           DELETE /api/v1/ecommerce/coupons/:couponId - Admin (200)
%% TODO: [toggle_status]    PATCH  /api/v1/ecommerce/coupons/status/:couponId - Admin, body: isActive (200)

init(Req0, State) ->
    %% TODO: implement
    {ok, Req0, State}.
