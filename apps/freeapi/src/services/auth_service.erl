-module(auth_service).

-export([generate_access_token/1, generate_refresh_token/0,
         verify_access_token/1, hash_refresh_token/1,
         google_oauth_url/0, github_oauth_url/0,
         exchange_google_code/1, exchange_github_code/1,
         fetch_google_user/1, fetch_github_user/1]).

%% TODO: Implement JWT token generation and verification
%%
%% generate_access_token(User) -> Token :: binary()
%%   User is a map with _id, username, email, role
%%   Create JWT with claims: sub, username, email, role, iat, exp
%%   Use HS256 algorithm, secret from app config (jwt_secret)
%%   TTL from app config (jwt_access_ttl, default 900s = 15min)
generate_access_token(_User) -> erlang:error(not_implemented).

%% generate_refresh_token() -> Token :: binary()
%%   Generate a random UUID v4 string (used as opaque refresh token)
generate_refresh_token() -> erlang:error(not_implemented).

%% verify_access_token(Token) -> {ok, Claims} | {error, expired | invalid}
%%   Decode JWT, verify signature, check exp claim
verify_access_token(_Token) -> erlang:error(not_implemented).

%% hash_refresh_token(Token) -> HashedToken :: binary()
%%   SHA256 hash for storing refresh token in database
hash_refresh_token(_Token) -> erlang:error(not_implemented).

%% TODO: Implement OAuth 2.0 helpers (used by user_h google/github handlers)
%%
%% google_oauth_url() -> URL :: binary()
%%   Build Google OAuth consent URL with client_id, redirect_uri, scope, state
google_oauth_url() -> erlang:error(not_implemented).

%% github_oauth_url() -> URL :: binary()
github_oauth_url() -> erlang:error(not_implemented).

%% exchange_google_code(Code) -> {ok, AccessToken} | {error, Reason}
%%   POST to Google token endpoint, exchange auth code for access token
%%   Use hackney for HTTP request
exchange_google_code(_Code) -> erlang:error(not_implemented).

%% exchange_github_code(Code) -> {ok, AccessToken} | {error, Reason}
exchange_github_code(_Code) -> erlang:error(not_implemented).

%% fetch_google_user(AccessToken) -> {ok, UserInfo} | {error, Reason}
%%   GET Google userinfo endpoint with access token
fetch_google_user(_AccessToken) -> erlang:error(not_implemented).

%% fetch_github_user(AccessToken) -> {ok, UserInfo} | {error, Reason}
fetch_github_user(_AccessToken) -> erlang:error(not_implemented).
