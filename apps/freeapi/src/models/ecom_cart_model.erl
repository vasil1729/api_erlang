-module(ecom_cart_model).
-export([get_or_create/1, add_item/3, remove_item/2, clear/1, apply_coupon/2, remove_coupon/1]).
%% TODO: Collection: <<"carts">>
%% get_or_create(UserId) -> {ok, Cart}  populate items with product details, calculate totals
%% add_item(UserId, ProductId, Quantity) -> {ok, Cart}  increment if exists, add if new
%% remove_item(UserId, ProductId) -> {ok, Cart}
%% clear(UserId) -> {ok, Cart}  remove all items + coupon, reset totals
%% apply_coupon(UserId, CouponId) -> {ok, Cart}
%% remove_coupon(UserId) -> {ok, Cart}
get_or_create(_UserId) -> erlang:error(not_implemented).
add_item(_UserId, _ProductId, _Qty) -> erlang:error(not_implemented).
remove_item(_UserId, _ProductId) -> erlang:error(not_implemented).
clear(_UserId) -> erlang:error(not_implemented).
apply_coupon(_UserId, _CouponId) -> erlang:error(not_implemented).
remove_coupon(_UserId) -> erlang:error(not_implemented).
