-module(ecom_product_model).
-export([create/2, find_all/1, find_by_id/1, update/2, delete/1, find_by_category/2, remove_subimage/2]).
%% TODO: Collection: <<"products">>
%% create(UserId, Data) -> {ok, Product}  Data includes mainImage, subImages file paths
%% find_all(Opts) -> {[Product], Total}  populate category
%% find_by_id(ProductId) -> {ok, Product} | not_found  populate category
%% update(ProductId, Updates) -> {ok, Product}
%% delete(ProductId) -> ok  delete image files from disk
%% find_by_category(CategoryId, Opts) -> {[Product], Total}
%% remove_subimage(ProductId, SubImageId) -> {ok, Product}  delete file from disk
create(_UserId, _Data) -> erlang:error(not_implemented).
find_all(_Opts) -> erlang:error(not_implemented).
find_by_id(_Id) -> erlang:error(not_implemented).
update(_Id, _Updates) -> erlang:error(not_implemented).
delete(_Id) -> erlang:error(not_implemented).
find_by_category(_CatId, _Opts) -> erlang:error(not_implemented).
remove_subimage(_ProdId, _ImgId) -> erlang:error(not_implemented).
