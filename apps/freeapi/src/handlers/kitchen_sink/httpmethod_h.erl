-module(httpmethod_h).
-behaviour(cowboy_handler).
-export([init/2]).

%% Handles 5 routes from API_SPEC 8.1:
%% TODO: [get_method]    GET    /api/v1/kitchen-sink/http-methods/get - echo method, body=null (200)
%% TODO: [post_method]   POST   /api/v1/kitchen-sink/http-methods/post - echo method+body (200)
%% TODO: [put_method]    PUT    /api/v1/kitchen-sink/http-methods/put - echo method+body (200)
%% TODO: [patch_method]  PATCH  /api/v1/kitchen-sink/http-methods/patch - echo method+body (200)
%% TODO: [delete_method] DELETE /api/v1/kitchen-sink/http-methods/delete - echo method, body=null (200)

init(Req0, State) ->
    %% TODO: implement
    {ok, Req0, State}.
