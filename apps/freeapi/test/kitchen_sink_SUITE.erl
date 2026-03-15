-module(kitchen_sink_SUITE).
-include_lib("common_test/include/ct.hrl").
-export([all/0, init_per_suite/1, end_per_suite/1]).
-export([http_methods_test/1, status_codes_test/1, request_inspect_test/1,
         response_inspect_test/1, cookies_test/1, redirect_test/1, images_test/1]).

%% TODO: Test all 27 kitchen sink endpoints

all() -> [http_methods_test, status_codes_test, request_inspect_test,
           response_inspect_test, cookies_test, redirect_test, images_test].
init_per_suite(Config) -> Config.
end_per_suite(_Config) -> ok.
http_methods_test(_Config) -> ok.
status_codes_test(_Config) -> ok.
request_inspect_test(_Config) -> ok.
response_inspect_test(_Config) -> ok.
cookies_test(_Config) -> ok.
redirect_test(_Config) -> ok.
images_test(_Config) -> ok.
