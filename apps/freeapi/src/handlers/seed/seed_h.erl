-module(seed_h).
-behaviour(cowboy_handler).
-export([init/2]).

%% Handles 6 routes from API_SPEC section 9:
%% TODO: [credentials]    GET    /api/v1/seed/generated-credentials - No auth. Return test user credentials list (200)
%% TODO: [seed_todos]     POST   /api/v1/seed/todos - Auth required. Seed 10-20 todos for current user (200)
%% TODO: [seed_ecommerce] POST   /api/v1/seed/ecommerce - Auth required. Seed categories,products,addresses (200)
%% TODO: [seed_social]    POST   /api/v1/seed/social-media - Auth required. Seed social profile,posts (200)
%% TODO: [seed_chat]      POST   /api/v1/seed/chat-app - Auth required. Seed chats,messages (200)
%% TODO: [reset_db]       DELETE /api/v1/reset-db - Admin only. Drop all, re-seed public data, create admin (200)

init(Req0, State) ->
    %% TODO: implement
    {ok, Req0, State}.
