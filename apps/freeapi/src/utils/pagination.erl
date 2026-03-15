-module(pagination).

-export([parse_query/1, paginate/3]).

%% TODO: Implement parse_query/1
%% Extract page and limit from cowboy_req query string.
%% Defaults: page=1, limit=10. Max limit=100.
%% Return {Page, Limit} as integers.
parse_query(_Req) -> erlang:error(not_implemented).

%% TODO: Implement paginate/3
%% paginate(Items, Page, Limit) -> {PagedItems, TotalCount}
%% For in-memory lists (used by public API JSON cache).
paginate(_Items, _Page, _Limit) -> erlang:error(not_implemented).
