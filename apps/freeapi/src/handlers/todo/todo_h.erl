-module(todo_h).
-behaviour(cowboy_handler).
-export([init/2]).

%% Handles 7 routes from API_SPEC section 4:
%%
%% TODO: [list]          GET /api/v1/todos
%%   Auth required. Query: page, limit, complete (bool filter), query (search title).
%%   Return paginated todos owned by current user. (200)
%%
%% TODO: [create]        POST /api/v1/todos
%%   Auth required. Body: title (required), description (optional).
%%   Create todo with owner=current user, isComplete=false. (201)
%%
%% TODO: [get_one]       GET /api/v1/todos/:todoId
%%   Auth required. Return todo if owned by user, else 404. (200)
%%
%% TODO: [update]        PATCH /api/v1/todos/:todoId
%%   Auth required. Body: title, description (optional). Update if owned. (200)
%%
%% TODO: [delete]        DELETE /api/v1/todos/:todoId
%%   Auth required. Delete if owned, else 404. (200)
%%
%% TODO: [toggle_status] PATCH /api/v1/todos/toggle/status/:todoId
%%   Auth required. Toggle isComplete (true<->false). Return updated todo. (200)

init(Req0, State) ->
    %% TODO: implement
    {ok, Req0, State}.
