-module(order_h).
-behaviour(cowboy_handler).
-export([init/2]).

%% Handles 7 routes from API_SPEC 5.6:
%% TODO: [create_razorpay]  POST  /api/v1/ecommerce/orders/provider/razorpay - Auth, body: addressId, create order+razorpay order (201)
%% TODO: [create_paypal]    POST  /api/v1/ecommerce/orders/provider/paypal - Auth, body: addressId, create order+paypal order (201)
%% TODO: [verify_razorpay]  POST  /api/v1/ecommerce/orders/provider/razorpay/verify-payment - Auth, verify signature, mark paid (200)
%% TODO: [verify_paypal]    POST  /api/v1/ecommerce/orders/provider/paypal/verify-payment - Auth, verify with paypal API (200)
%% TODO: [get_one]          GET   /api/v1/ecommerce/orders/:orderId - Auth, must be owner or admin (200)
%% TODO: [list_admin]       GET   /api/v1/ecommerce/orders/list/admin - Admin, paginated, status filter (200)
%% TODO: [update_status]    PATCH /api/v1/ecommerce/orders/status/:orderId - Admin, body: status enum (200)

init(Req0, State) ->
    %% TODO: implement
    {ok, Req0, State}.
