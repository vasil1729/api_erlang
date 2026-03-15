-module(freeapi_app).
-behaviour(application).

-export([start/2, stop/1]).

%% TODO: Implement application start
%% 1. Call override_from_env/0 to load OS env vars into app config
%% 2. Start top-level supervisor freeapi_sup
%% 3. Build dispatch routes via freeapi_router:dispatch/0
%% 4. Start cowboy listener on configured http_port with middlewares:
%%    - freeapi_mw_cors
%%    - cowboy_router
%%    - cowboy_handler
%% 5. Log startup message with port number

start(_StartType, _StartArgs) ->
    %% TODO: implement
    {ok, self()}.

stop(_State) ->
    ok.

%% TODO: Implement override_from_env/0
%% Read OS environment variables and override app config:
%%   PORT -> http_port (integer)
%%   JWT_SECRET -> jwt_secret (binary)
%%   MONGODB_URI -> db_host (string)
%%   DB_NAME -> db_name (binary)
%%   GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET
%%   GITHUB_CLIENT_ID, GITHUB_CLIENT_SECRET
%%   FRONTEND_URL -> frontend_url (binary)
