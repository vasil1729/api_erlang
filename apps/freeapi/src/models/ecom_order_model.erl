-module(ecom_order_model).
-export([create/3, find_by_id/1, find_by_customer/2, find_all_admin/1, update_status/2, mark_paid/2]).
%% TODO: Collection: <<"orders">>
%% create(UserId, AddressId, PaymentProvider) -> {ok, Order}  create from cart, clear cart
%% find_by_id(OrderId) -> {ok, Order} | not_found
%% find_by_customer(UserId, Opts) -> {[Order], Total}
%% find_all_admin(Opts) -> {[Order], Total}  with optional status filter
%% update_status(OrderId, Status) -> {ok, Order}  Status: PENDING|CANCELLED|DELIVERED
%% mark_paid(OrderId, PaymentId) -> {ok, Order}  set isPaymentDone=true
create(_UserId, _AddressId, _Provider) -> erlang:error(not_implemented).
find_by_id(_Id) -> erlang:error(not_implemented).
find_by_customer(_UserId, _Opts) -> erlang:error(not_implemented).
find_all_admin(_Opts) -> erlang:error(not_implemented).
update_status(_Id, _Status) -> erlang:error(not_implemented).
mark_paid(_Id, _PaymentId) -> erlang:error(not_implemented).
