-module(product_h).
-behaviour(cowboy_handler).
-export([init/2]).

%% Handles 7 routes from API_SPEC 5.3:
%% TODO: [list]            GET   /api/v1/ecommerce/products - Auth, paginated, populate category (200)
%% TODO: [create]          POST  /api/v1/ecommerce/products - Admin, multipart: name,desc,price,stock,category,mainImage,subImages (201)
%% TODO: [get_one]         GET   /api/v1/ecommerce/products/:productId - Auth, populate category (200/404)
%% TODO: [update]          PATCH /api/v1/ecommerce/products/:productId - Admin, multipart optional fields (200)
%% TODO: [delete]          DELETE /api/v1/ecommerce/products/:productId - Admin, delete images from disk (200)
%% TODO: [by_category]     GET   /api/v1/ecommerce/products/category/:categoryId - Auth, paginated (200)
%% TODO: [remove_subimage] PATCH /api/v1/ecommerce/products/remove/subimage/:productId/:subImageId - Admin (200)

init(Req0, State) ->
    %% TODO: implement
    {ok, Req0, State}.
