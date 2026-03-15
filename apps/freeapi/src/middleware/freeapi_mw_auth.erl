-module(freeapi_mw_auth).

-export([require/1, require_admin/1, optional/1]).

%% TODO: Implement require/1
%% Extract Bearer token from Authorization header of cowboy Req.
%% Call auth_service:verify_access_token/1 to decode & validate JWT.
%% On success: return {ok, UserClaims, Req}
%%   UserClaims is a map: #{<<"sub">> => UserId, <<"username">> => ..., <<"email">> => ..., <<"role">> => ...}
%% On failure (missing header, invalid/expired token):
%%   return {error, Req} where Req has 401 JSON error response already set via response:error/3

require(_Req) ->
    %% TODO: implement
    erlang:error(not_implemented).

%% TODO: Implement require_admin/1
%% Call require/1 first. If successful, check that role == <<"ADMIN">>.
%% Return {ok, User, Req} if admin, {error, Req} with 403 if not admin.

require_admin(_Req) ->
    %% TODO: implement
    erlang:error(not_implemented).

%% TODO: Implement optional/1
%% Try to extract and verify token. If present and valid, return {ok, UserClaims, Req}.
%% If missing or invalid, return {anonymous, Req} (no error response).

optional(_Req) ->
    %% TODO: implement
    erlang:error(not_implemented).
