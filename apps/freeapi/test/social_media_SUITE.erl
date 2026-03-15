-module(social_media_SUITE).
-include_lib("common_test/include/ct.hrl").
-export([all/0, init_per_suite/1, end_per_suite/1]).
-export([profile_test/1, posts_test/1, comments_test/1, likes_test/1,
         bookmarks_test/1, follow_test/1]).

%% TODO: Test all 24 social media endpoints

all() -> [profile_test, posts_test, comments_test, likes_test, bookmarks_test, follow_test].
init_per_suite(Config) -> Config.
end_per_suite(_Config) -> ok.
profile_test(_Config) -> ok.
posts_test(_Config) -> ok.
comments_test(_Config) -> ok.
likes_test(_Config) -> ok.
bookmarks_test(_Config) -> ok.
follow_test(_Config) -> ok.
