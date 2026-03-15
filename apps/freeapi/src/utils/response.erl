-module(response).

-export([success/3, created/3, paginated/6, error/3, error/4, no_content/1]).

%% TODO: Implement standard JSON response envelope helpers
%% All functions take a cowboy Req and return an updated Req with JSON body sent.
%% Use jiffy:encode/1 for JSON serialization.
%% Set content-type header to application/json.

%% TODO: success(Req, StatusCode, Data) -> Req
%% Returns: {"statusCode": N, "data": Data, "message": "Success", "success": true}
success(_Req, _Status, _Data) -> erlang:error(not_implemented).

%% TODO: created(Req, StatusCode, Data) -> Req  (for 201 responses)
created(_Req, _Status, _Data) -> erlang:error(not_implemented).

%% TODO: paginated(Req, Status, Items, Page, Limit, TotalItems) -> Req
%% Returns standard envelope plus "pagination" key:
%% {"page": N, "limit": N, "totalItems": N, "totalPages": N, "hasNext": bool, "hasPrev": bool}
paginated(_Req, _Status, _Items, _Page, _Limit, _Total) -> erlang:error(not_implemented).

%% TODO: error(Req, StatusCode, Message) -> Req
%% Returns: {"statusCode": N, "data": null, "message": Msg, "success": false, "errors": []}
error(_Req, _Status, _Message) -> erlang:error(not_implemented).

%% TODO: error(Req, StatusCode, Message, Errors) -> Req
%% Errors = [#{<<"field">> => FieldName, <<"message">> => ErrMsg}]
error(_Req, _Status, _Message, _Errors) -> erlang:error(not_implemented).

%% TODO: no_content(Req) -> Req  (204 with no body)
no_content(_Req) -> erlang:error(not_implemented).
