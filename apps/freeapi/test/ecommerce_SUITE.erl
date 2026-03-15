-module(ecommerce_SUITE).
-include_lib("common_test/include/ct.hrl").
-export([all/0, init_per_suite/1, end_per_suite/1]).
-export([categories_test/1, products_test/1, cart_test/1, orders_test/1,
         coupons_test/1, addresses_test/1, profile_test/1]).

%% TODO: Test all 40 ecommerce endpoints

all() -> [categories_test, products_test, cart_test, orders_test,
           coupons_test, addresses_test, profile_test].
init_per_suite(Config) -> Config.
end_per_suite(_Config) -> ok.
categories_test(_Config) -> ok.
products_test(_Config) -> ok.
cart_test(_Config) -> ok.
orders_test(_Config) -> ok.
coupons_test(_Config) -> ok.
addresses_test(_Config) -> ok.
profile_test(_Config) -> ok.
