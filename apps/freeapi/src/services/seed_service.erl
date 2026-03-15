-module(seed_service).

-export([get_credentials/0, seed_todos/1, seed_ecommerce/1,
         seed_social_media/1, seed_chat_app/1, reset_db/0]).

%% TODO: Implement database seeding logic
%%
%% get_credentials() -> [#{username, email, password, role}]
%%   Return pre-generated test user credentials (hardcoded list)
%%   Used by GET /api/v1/seed/generated-credentials
get_credentials() -> erlang:error(not_implemented).

%% seed_todos(UserId) -> ok
%%   Create 10-20 sample todos for the given user
%%   Used by POST /api/v1/seed/todos (requires auth)
seed_todos(_UserId) -> erlang:error(not_implemented).

%% seed_ecommerce(UserId) -> ok
%%   Create sample categories, products, addresses for the user
%%   Used by POST /api/v1/seed/ecommerce (requires auth)
seed_ecommerce(_UserId) -> erlang:error(not_implemented).

%% seed_social_media(UserId) -> ok
%%   Create sample social profile, posts for the user
%%   Used by POST /api/v1/seed/social-media (requires auth)
seed_social_media(_UserId) -> erlang:error(not_implemented).

%% seed_chat_app(UserId) -> ok
%%   Create sample chats, messages for the user
%%   Used by POST /api/v1/seed/chat-app (requires auth)
seed_chat_app(_UserId) -> erlang:error(not_implemented).

%% reset_db() -> ok
%%   Drop all collections, re-seed public data from JSON files, create default admin
%%   Used by DELETE /api/v1/reset-db (requires admin auth)
reset_db() -> erlang:error(not_implemented).
