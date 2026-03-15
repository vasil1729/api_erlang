-module(chat_SUITE).
-include_lib("common_test/include/ct.hrl").
-export([all/0, init_per_suite/1, end_per_suite/1]).
-export([one_on_one_test/1, group_chat_test/1, messages_test/1, websocket_test/1]).

%% TODO: Test all 14 chat app endpoints + WebSocket events

all() -> [one_on_one_test, group_chat_test, messages_test, websocket_test].
init_per_suite(Config) -> Config.
end_per_suite(_Config) -> ok.
one_on_one_test(_Config) -> ok.
group_chat_test(_Config) -> ok.
messages_test(_Config) -> ok.
websocket_test(_Config) -> ok.
