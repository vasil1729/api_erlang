-module(healthcheck_SUITE).
-include_lib("common_test/include/ct.hrl").
-export([all/0, init_per_suite/1, end_per_suite/1]).
-export([healthcheck_test/1]).

all() -> [healthcheck_test].

init_per_suite(Config) ->
    {ok, _} = application:ensure_all_started(freeapi),
    inets:start(),
    Config.

end_per_suite(_Config) ->
    application:stop(freeapi),
    inets:stop(),
    ok.

healthcheck_test(_Config) ->
    Url = "http://localhost:8080/api/v1/healthcheck",
    {ok, {{_Version, 200, _ReasonPhrase}, _Headers, Body}} = httpc:request(get, {Url, []}, [], []),
    ExpectedBody = #{
        <<"statusCode">> => 200,
        <<"message">> => <<"OK">>,
        <<"success">> => true,
        <<"data">> => null
    },
    ExpectedBody = jiffy:decode(Body, [return_maps]),
    ok.
