-module(public_api_SUITE).
-include_lib("common_test/include/ct.hrl").
-export([all/0, init_per_suite/1, end_per_suite/1]).
-export([randomusers_list_test/1, randomusers_by_id_test/1, randomusers_random_test/1,
         randomproducts_list_test/1, books_list_test/1, jokes_list_test/1,
         quotes_list_test/1, meals_list_test/1, dogs_list_test/1,
         cats_list_test/1, stocks_list_test/1, youtube_channel_test/1]).

%% TODO: Implement integration tests for all 34 public API endpoints
%% Test pagination, search/query, field filtering (inc), 404 for invalid IDs, random endpoint

all() -> [randomusers_list_test, randomusers_by_id_test, randomusers_random_test,
           randomproducts_list_test, books_list_test, jokes_list_test,
           quotes_list_test, meals_list_test, dogs_list_test,
           cats_list_test, stocks_list_test, youtube_channel_test].

init_per_suite(Config) -> Config.
end_per_suite(_Config) -> ok.

randomusers_list_test(_Config) -> ok.
randomusers_by_id_test(_Config) -> ok.
randomusers_random_test(_Config) -> ok.
randomproducts_list_test(_Config) -> ok.
books_list_test(_Config) -> ok.
jokes_list_test(_Config) -> ok.
quotes_list_test(_Config) -> ok.
meals_list_test(_Config) -> ok.
dogs_list_test(_Config) -> ok.
cats_list_test(_Config) -> ok.
stocks_list_test(_Config) -> ok.
youtube_channel_test(_Config) -> ok.
