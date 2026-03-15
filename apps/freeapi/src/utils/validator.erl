-module(validator).

-export([validate/2, is_valid_email/1, is_valid_objectid/1]).

%% TODO: Implement validate/2
%% validate(Body, Rules) -> ok | {error, Errors}
%% Body :: map(), Rules :: [{FieldName, [required | {min_length, N} | {max_length, N} | email | objectid]}]
%% Returns ok or {error, [#{<<"field">> => F, <<"message">> => Msg}]}
validate(_Body, _Rules) -> erlang:error(not_implemented).

%% TODO: is_valid_email(Binary) -> boolean()
is_valid_email(_Email) -> erlang:error(not_implemented).

%% TODO: is_valid_objectid(Binary) -> boolean()
%% Check if it's a 24-char hex string (MongoDB ObjectId format)
is_valid_objectid(_Id) -> erlang:error(not_implemented).
