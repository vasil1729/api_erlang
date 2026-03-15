-module(todo_SUITE).
-include_lib("common_test/include/ct.hrl").
-export([all/0, init_per_suite/1, end_per_suite/1]).
-export([crud_test/1, toggle_status_test/1, pagination_test/1]).

%% TODO: Test all 7 todo endpoints (create, list, get, update, delete, toggle)

all() -> [crud_test, toggle_status_test, pagination_test].
init_per_suite(Config) -> Config.
end_per_suite(_Config) -> ok.
crud_test(_Config) -> ok.
toggle_status_test(_Config) -> ok.
pagination_test(_Config) -> ok.
