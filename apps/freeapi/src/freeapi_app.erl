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
    override_from_env(),
    Port = application:get_env(freeapi, http_port, 8080),
    Dispatch = freeapi_router:dispatch(),

    %% Start Cowboy
    {ok, _} = cowboy:start_clear(http_listener,
        [{port, Port}],
        #{env => #{dispatch => Dispatch},
          middlewares => [
              freeapi_mw_cors,
              cowboy_router,
              cowboy_handler
          ]}
    ),

    logger:info("Started FreeAPI on port ~p", [Port]),
    freeapi_sup:start_link().

stop(_State) ->
    cowboy:stop_listener(http_listener),
    ok.

override_from_env() ->
    Mappings = [
        {"PORT", http_port, fun list_to_integer/1},
        {"JWT_SECRET", jwt_secret, fun list_to_binary/1},
        {"MONGODB_URI", db_host, fun(V) -> V end},
        {"DB_NAME", db_name, fun list_to_binary/1},
        {"GOOGLE_CLIENT_ID", google_client_id, fun list_to_binary/1},
        {"GOOGLE_CLIENT_SECRET", google_client_secret, fun list_to_binary/1},
        {"GITHUB_CLIENT_ID", github_client_id, fun list_to_binary/1},
        {"GITHUB_CLIENT_SECRET", github_client_secret, fun list_to_binary/1},
        {"FRONTEND_URL", frontend_url, fun list_to_binary/1}
    ],
    lists:foreach(fun({EnvKey, AppKey, Transform}) ->
        case os:getenv(EnvKey) of
            false -> ok;
            Value -> application:set_env(freeapi, AppKey, Transform(Value))
        end
    end, Mappings).
