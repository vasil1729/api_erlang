-module(ecom_category_model).
-export([create/2, find_all/1, find_by_id/1, update/2, delete/1]).
%% TODO: Collection: <<"categories">>
%% create(UserId, #{name}) -> {ok, Category}
%% find_all(Opts) -> {[Category], Total}  (paginated)
%% find_by_id(CategoryId) -> {ok, Category} | not_found
%% update(CategoryId, #{name}) -> {ok, Category} | not_found
%% delete(CategoryId) -> ok | not_found  (cascade delete products in category)
create(_UserId, _Data) -> erlang:error(not_implemented).
find_all(_Opts) -> erlang:error(not_implemented).
find_by_id(_Id) -> erlang:error(not_implemented).
update(_Id, _Updates) -> erlang:error(not_implemented).
delete(_Id) -> erlang:error(not_implemented).
