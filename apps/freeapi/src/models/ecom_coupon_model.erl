-module(ecom_coupon_model).
-export([create/2, find_all/1, find_by_id/1, find_by_code/1, update/2, delete/1,
         find_available/1, toggle_status/2]).
%% TODO: Collection: <<"coupons">>
%% create(UserId, Data) -> {ok, Coupon}  uppercase couponCode
%% find_all(Opts) -> {[Coupon], Total}
%% find_by_id(CouponId) -> {ok, Coupon} | not_found
%% find_by_code(Code) -> {ok, Coupon} | not_found  case-insensitive
%% update(CouponId, Updates) -> {ok, Coupon}
%% delete(CouponId) -> ok
%% find_available(Opts) -> {[Coupon], Total}  isActive=true, not expired
%% toggle_status(CouponId, IsActive) -> {ok, Coupon}
create(_UserId, _Data) -> erlang:error(not_implemented).
find_all(_Opts) -> erlang:error(not_implemented).
find_by_id(_Id) -> erlang:error(not_implemented).
find_by_code(_Code) -> erlang:error(not_implemented).
update(_Id, _Updates) -> erlang:error(not_implemented).
delete(_Id) -> erlang:error(not_implemented).
find_available(_Opts) -> erlang:error(not_implemented).
toggle_status(_Id, _IsActive) -> erlang:error(not_implemented).
