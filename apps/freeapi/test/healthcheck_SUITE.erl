-module(healthcheck_SUITE).
-include_lib("common_test/include/ct.hrl").
-export([all/0, init_per_suite/1, end_per_suite/1]).
-export([healthcheck_test/1]).

%% TODO: Implement integration tests for healthcheck
%% 1. In init_per_suite: start the application, get base URL
%% 2. healthcheck_test: GET /api/v1/healthcheck, assert 200 + correct JSON body
%% 3. In end_per_suite: stop the application

all() -> [healthcheck_test].
init_per_suite(Config) -> Config.
end_per_suite(_Config) -> ok.
healthcheck_test(_Config) ->
    %% TODO: implement
    ok.
