-module(response).

-export([success/3, created/3, paginated/6, error/3, error/4, no_content/1]).

%% TODO: Implement standard JSON response envelope helpers
%% All functions take a cowboy Req and return an updated Req with JSON body sent.
%% Use jiffy:encode/1 for JSON serialization.
%% Set content-type header to application/json.

success(Req, Status, Data) ->
    Message = case Status of
        200 -> <<"OK">>;
        _ -> <<"Success">>
    end,
    Body = jiffy:encode(#{
        <<"statusCode">> => Status,
        <<"data">> => Data,
        <<"message">> => Message,
        <<"success">> => true
    }),
    cowboy_req:reply(Status, #{<<"content-type">> => <<"application/json">>}, Body, Req).

created(Req, Status, Data) ->
    Body = jiffy:encode(#{
        <<"statusCode">> => Status,
        <<"data">> => Data,
        <<"message">> => <<"Created">>,
        <<"success">> => true
    }),
    cowboy_req:reply(Status, #{<<"content-type">> => <<"application/json">>}, Body, Req).

paginated(Req, Status, Items, Page, Limit, Total) ->
    TotalPages = (Total + Limit - 1) div Limit,
    Body = jiffy:encode(#{
        <<"statusCode">> => Status,
        <<"data">> => Items,
        <<"message">> => <<"Success">>,
        <<"success">> => true,
        <<"pagination">> => #{
            <<"page">> => Page,
            <<"limit">> => Limit,
            <<"totalItems">> => Total,
            <<"totalPages">> => TotalPages,
            <<"hasNext">> => Page < TotalPages,
            <<"hasPrev">> => Page > 1
        }
    }),
    cowboy_req:reply(Status, #{<<"content-type">> => <<"application/json">>}, Body, Req).

error(Req, Status, Message) ->
    error(Req, Status, Message, []).

error(Req, Status, Message, Errors) ->
    Body = jiffy:encode(#{
        <<"statusCode">> => Status,
        <<"data">> => null,
        <<"message">> => Message,
        <<"success">> => false,
        <<"errors">> => Errors
    }),
    cowboy_req:reply(Status, #{<<"content-type">> => <<"application/json">>}, Body, Req).

no_content(Req) ->
    cowboy_req:reply(204, #{}, <<>>, Req).
