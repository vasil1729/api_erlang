-module(category_h).
-behaviour(cowboy_handler).
-export([init/2]).

%% Handles 5 routes from API_SPEC 5.1:
%% TODO: [list]    GET    /api/v1/ecommerce/categories - Auth, paginated (200)
%% TODO: [create]  POST   /api/v1/ecommerce/categories - Admin only, body: name (201)
%% TODO: [get_one] GET    /api/v1/ecommerce/categories/:categoryId - Auth (200/404)
%% TODO: [update]  PATCH  /api/v1/ecommerce/categories/:categoryId - Admin, body: name (200)
%% TODO: [delete]  DELETE /api/v1/ecommerce/categories/:categoryId - Admin, cascade delete products (200)

init(Req0, State) ->
    %% TODO: implement
    {ok, Req0, State}.
