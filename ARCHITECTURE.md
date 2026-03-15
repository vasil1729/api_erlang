# FreeAPI Erlang — Architecture Blueprint

> **Purpose**: State-of-the-art architectural blueprint for implementing the full 168-endpoint FreeAPI Hub in Erlang/OTP.  
> **Design Philosophy**: Leverage OTP's supervision trees, process isolation, and "let it crash" philosophy to build a fault-tolerant, massively concurrent API server.

---

## Table of Contents

1. [Technology Stack](#1-technology-stack)
2. [Project Structure](#2-project-structure)
3. [OTP Application Architecture](#3-otp-application-architecture)
4. [Supervision Tree](#4-supervision-tree)
5. [Routing & Handler Design](#5-routing--handler-design)
6. [Middleware Pipeline](#6-middleware-pipeline)
7. [Authentication & Authorization](#7-authentication--authorization)
8. [Database Layer](#8-database-layer)
9. [JSON Data (Public APIs)](#9-json-data-public-apis)
10. [WebSocket (Chat App)](#10-websocket-chat-app)
11. [File Upload & Static Assets](#11-file-upload--static-assets)
12. [Configuration Management](#12-configuration-management)
13. [Error Handling](#13-error-handling)
14. [Testing Strategy](#14-testing-strategy)
15. [Build, Release & Deployment](#15-build-release--deployment)
16. [Library Reference](#16-library-reference)

---

## 1. Technology Stack

| Concern | Library | Hex Package | Why |
|---|---|---|---|
| **Build tool** | rebar3 | — | Standard Erlang build tool, hex integration, release management |
| **HTTP server** | Cowboy 2.x | `cowboy` | The de facto Erlang HTTP/1.1 + HTTP/2 + WebSocket server by Loïc Hoguin (ninenines). Battle-tested, high performance |
| **Routing** | Cowboy Router | built-in | Cowboy's built-in path-based dispatch with constraints |
| **JSON codec** | jiffy | `jiffy` | NIF-based JSON encoder/decoder — fastest option for Erlang. Falls back to `jsx` (pure Erlang) for environments where NIFs are not desired |
| **Database driver** | mongodb-erlang | `mongodb` | Official community MongoDB driver for Erlang with connection pooling |
| **Connection pool** | poolboy | `poolboy` | Generic worker pool — used to pool MongoDB connections |
| **JWT** | jwt | `jwt` | Lightweight Erlang JWT library (artemeff/jwt) — sign/verify HS256/RS256 |
| **Password hashing** | bcrypt | `bcrypt` | NIF wrapper around the OpenBSD bcrypt C library |
| **UUID generation** | uuid | `uuid` | Generate v4 UUIDs for tokens, file names |
| **Date/Time** | qdate | `qdate` | Timezone-aware date/time formatting and conversion |
| **Email (mock)** | gen_smtp | `gen_smtp` | SMTP client for sending verification/reset emails (can be mocked) |
| **HTTP client** | hackney | `hackney` | Used for OAuth callbacks (Google, GitHub token exchange) |
| **Logging** | logger (OTP) | built-in | OTP 21+ structured logger — no external dependency needed |
| **Config** | sys.config + env | built-in | OTP application env, overridable via OS environment variables |
| **Testing** | Common Test + EUnit | built-in | Standard OTP testing frameworks |
| **Property testing** | PropEr | `proper` | QuickCheck-inspired property-based testing |
| **Release** | rebar3 release | built-in | Produce self-contained OTP releases with `relx` |

---

## 2. Project Structure

```
api_erlang/
├── API_SPEC.md                    # Full API specification (168 endpoints)
├── ARCHITECTURE.md                # This file
├── rebar.config                   # Dependencies, plugins, release config
├── config/
│   ├── sys.config                 # App environment (db, jwt secrets, etc.)
│   └── vm.args                    # BEAM VM flags (+P, +K, schedulers)
├── apps/
│   └── freeapi/
│       ├── src/
│       │   ├── freeapi_app.erl               # Application behaviour
│       │   ├── freeapi_sup.erl               # Top-level supervisor
│       │   ├── freeapi.app.src               # Application resource file
│       │   │
│       │   ├── router/
│       │   │   └── freeapi_router.erl        # Cowboy dispatch table assembly
│       │   │
│       │   ├── middleware/
│       │   │   ├── freeapi_mw_auth.erl       # JWT verification middleware
│       │   │   ├── freeapi_mw_cors.erl       # CORS headers middleware
│       │   │   └── freeapi_mw_ratelimit.erl  # Rate limiting middleware
│       │   │
│       │   ├── handlers/
│       │   │   ├── healthcheck_h.erl
│       │   │   ├── public/
│       │   │   │   ├── randomuser_h.erl
│       │   │   │   ├── randomproduct_h.erl
│       │   │   │   ├── randomjoke_h.erl
│       │   │   │   ├── book_h.erl
│       │   │   │   ├── quote_h.erl
│       │   │   │   ├── meal_h.erl
│       │   │   │   ├── dog_h.erl
│       │   │   │   ├── cat_h.erl
│       │   │   │   ├── stock_h.erl
│       │   │   │   └── youtube_h.erl
│       │   │   ├── auth/
│       │   │   │   └── user_h.erl
│       │   │   ├── todo/
│       │   │   │   └── todo_h.erl
│       │   │   ├── ecommerce/
│       │   │   │   ├── category_h.erl
│       │   │   │   ├── product_h.erl
│       │   │   │   ├── cart_h.erl
│       │   │   │   ├── order_h.erl
│       │   │   │   ├── coupon_h.erl
│       │   │   │   ├── address_h.erl
│       │   │   │   └── ecom_profile_h.erl
│       │   │   ├── social_media/
│       │   │   │   ├── sm_profile_h.erl
│       │   │   │   ├── sm_post_h.erl
│       │   │   │   ├── sm_comment_h.erl
│       │   │   │   ├── sm_like_h.erl
│       │   │   │   ├── sm_bookmark_h.erl
│       │   │   │   └── sm_follow_h.erl
│       │   │   ├── chat/
│       │   │   │   ├── chat_h.erl
│       │   │   │   ├── message_h.erl
│       │   │   │   └── chat_ws_h.erl          # WebSocket handler
│       │   │   ├── kitchen_sink/
│       │   │   │   ├── httpmethod_h.erl
│       │   │   │   ├── statuscode_h.erl
│       │   │   │   ├── request_inspect_h.erl
│       │   │   │   ├── response_inspect_h.erl
│       │   │   │   ├── cookie_h.erl
│       │   │   │   ├── redirect_h.erl
│       │   │   │   └── image_h.erl
│       │   │   └── seed/
│       │   │       └── seed_h.erl
│       │   │
│       │   ├── models/
│       │   │   ├── user_model.erl             # User CRUD, password hashing, token gen
│       │   │   ├── todo_model.erl
│       │   │   ├── ecom_category_model.erl
│       │   │   ├── ecom_product_model.erl
│       │   │   ├── ecom_cart_model.erl
│       │   │   ├── ecom_order_model.erl
│       │   │   ├── ecom_coupon_model.erl
│       │   │   ├── ecom_address_model.erl
│       │   │   ├── ecom_profile_model.erl
│       │   │   ├── sm_profile_model.erl
│       │   │   ├── sm_post_model.erl
│       │   │   ├── sm_comment_model.erl
│       │   │   ├── sm_like_model.erl
│       │   │   ├── sm_bookmark_model.erl
│       │   │   ├── sm_follow_model.erl
│       │   │   ├── chat_model.erl
│       │   │   └── message_model.erl
│       │   │
│       │   ├── services/
│       │   │   ├── auth_service.erl           # JWT issue/verify, OAuth flows
│       │   │   ├── email_service.erl          # Send verification/reset emails
│       │   │   ├── upload_service.erl         # File save/delete, path management
│       │   │   └── seed_service.erl           # Database seeding logic
│       │   │
│       │   ├── db/
│       │   │   ├── freeapi_db_sup.erl         # DB pool supervisor
│       │   │   ├── freeapi_db.erl             # MongoDB query helpers
│       │   │   └── freeapi_db_worker.erl      # Poolboy worker wrapping mongo connection
│       │   │
│       │   └── utils/
│       │       ├── response.erl               # Standard JSON response envelope helpers
│       │       ├── pagination.erl             # Pagination query/response builder
│       │       ├── validator.erl              # Input validation utilities
│       │       └── crypto_util.erl            # SHA256 hashing, random token gen
│       │
│       ├── priv/
│       │   ├── data/                          # Static JSON data files
│       │   │   ├── randomusers.json
│       │   │   ├── randomproducts.json
│       │   │   ├── randomjokes.json
│       │   │   ├── books.json
│       │   │   ├── quotes.json
│       │   │   ├── meals.json
│       │   │   ├── dogs.json
│       │   │   ├── cats.json
│       │   │   └── stocks.json
│       │   ├── images/                        # Kitchen sink sample images
│       │   │   ├── sample.jpeg
│       │   │   ├── sample.jpg
│       │   │   ├── sample.png
│       │   │   ├── sample.svg
│       │   │   └── sample.webp
│       │   ├── templates/
│       │   │   └── hello.html                 # Kitchen sink HTML response
│       │   └── uploads/                       # User-uploaded files (avatars, etc.)
│       │
│       └── test/
│           ├── healthcheck_SUITE.erl
│           ├── public_api_SUITE.erl
│           ├── auth_SUITE.erl
│           ├── todo_SUITE.erl
│           ├── ecommerce_SUITE.erl
│           ├── social_media_SUITE.erl
│           ├── chat_SUITE.erl
│           └── kitchen_sink_SUITE.erl
│
├── Dockerfile
├── docker-compose.yml
└── .gitignore
```

---

## 3. OTP Application Architecture

The project is a single OTP application (`freeapi`) structured as an **umbrella-ready** rebar3 project under `apps/`. This allows adding separate OTP apps later if needed (e.g., a metrics app).

### Application Startup Flow

```
freeapi_app:start/2
  └─► freeapi_sup:start_link/0          (top-level supervisor)
        ├─► freeapi_db_sup:start_link/0  (DB pool supervisor)
        │     └─► poolboy pool            (N MongoDB connection workers)
        ├─► freeapi_json_cache            (gen_server: loads static JSON into ETS)
        ├─► freeapi_chat_registry         (gen_server: tracks WS pids per chat)
        └─► cowboy:start_clear/3          (HTTP listener on configured port)
```

### Key Design Decisions

1. **One process per WebSocket connection** — Cowboy spawns a process per WS client. The `chat_ws_h` handler registers its pid in `freeapi_chat_registry` to enable broadcasting.
2. **ETS for static data** — Public API JSON data is loaded once at startup into named ETS tables. Handlers read directly from ETS (zero-copy for binaries), making reads lock-free and constant-time for ID lookups.
3. **Poolboy for DB connections** — A pool of `freeapi_db_worker` processes, each holding a persistent MongoDB connection. Handlers checkout a worker, run a query, and return it.

---

## 4. Supervision Tree

```
freeapi_sup (one_for_one)
│
├── freeapi_db_sup (one_for_one)
│   └── poolboy:start_link(freeapi_db_pool, ...)
│       ├── freeapi_db_worker #1   (gen_server holding mongo connection)
│       ├── freeapi_db_worker #2
│       └── ... (pool_size from config, default 10)
│
├── freeapi_json_cache (gen_server)
│   ├── Loads all priv/data/*.json into ETS on init
│   └── Provides get_all/2, get_by_id/3, get_random/2, search/3
│
├── freeapi_chat_registry (gen_server)
│   ├── Monitors WS process pids
│   ├── Maps chat_id → [pid()]
│   └── Cleans up on process DOWN
│
└── cowboy listener (managed via ranch)
    └── Per-connection handler processes (managed by cowboy)
```

### Restart Strategies

| Supervisor | Strategy | Rationale |
|---|---|---|
| `freeapi_sup` | `one_for_one` | Independent children — DB, cache, HTTP server can restart independently |
| `freeapi_db_sup` | `one_for_one` | Pool crash shouldn't take down the whole app |

---

## 5. Routing & Handler Design

### Cowboy Dispatch Table

Routes are assembled in `freeapi_router:dispatch/0` and passed to `cowboy:start_clear/3`.

```erlang
%% freeapi_router.erl
dispatch() ->
    cowboy_router:compile([
        {'_', [
            %% Healthcheck
            {"/api/v1/healthcheck", healthcheck_h, []},

            %% Public APIs (example pattern — repeated for each resource)
            {"/api/v1/public/randomusers", randomuser_h, [list]},
            {"/api/v1/public/randomusers/user/random", randomuser_h, [random]},
            {"/api/v1/public/randomusers/:userId", randomuser_h, [get_one]},

            %% Auth
            {"/api/v1/users/register", user_h, [register]},
            {"/api/v1/users/login", user_h, [login]},
            %% ... etc.

            %% WebSocket
            {"/ws/chat", chat_ws_h, []}
        ]}
    ]).
```

### Handler Pattern

Each handler implements the `cowboy_handler` behaviour (or `cowboy_rest` for RESTful resources). The action atom passed in `Opts` determines which function clause handles the request:

```erlang
-module(randomuser_h).
-behaviour(cowboy_handler).

-export([init/2]).

init(Req0, [list]) ->
    %% GET /api/v1/public/randomusers
    {Page, Limit} = pagination:parse_query(Req0),
    {Items, Total} = freeapi_json_cache:get_page(randomusers, Page, Limit),
    Req = response:paginated(Req0, 200, Items, Page, Limit, Total),
    {ok, Req, []};

init(Req0, [get_one]) ->
    %% GET /api/v1/public/randomusers/:userId
    UserId = cowboy_req:binding(userId, Req0),
    case freeapi_json_cache:get_by_id(randomusers, UserId) of
        {ok, Item} ->
            Req = response:success(Req0, 200, Item),
            {ok, Req, []};
        not_found ->
            Req = response:error(Req0, 404, <<"User not found">>),
            {ok, Req, []}
    end;

init(Req0, [random]) ->
    %% GET /api/v1/public/randomusers/user/random
    Item = freeapi_json_cache:get_random(randomusers),
    Req = response:success(Req0, 200, Item),
    {ok, Req, []}.
```

### Authenticated Handler Pattern

Handlers requiring auth call the middleware helper first:

```erlang
init(Req0, [create]) ->
    case freeapi_mw_auth:require(Req0) of
        {ok, User, Req1} ->
            %% proceed with authenticated user
            Body = read_json_body(Req1),
            Result = todo_model:create(User, Body),
            Req = response:success(Req1, 201, Result),
            {ok, Req, []};
        {error, Req1} ->
            {ok, Req1, []}
    end.
```

---

## 6. Middleware Pipeline

Cowboy supports **stream handlers** and **middlewares** via `cowboy:start_clear/3` options. We use a layered approach:

### Execution Order

```
Request
  │
  ▼
┌─────────────────────┐
│  freeapi_mw_cors     │  ← Sets CORS headers, handles OPTIONS preflight
└──────────┬──────────┘
           ▼
┌─────────────────────┐
│  cowboy_router       │  ← Built-in: matches route → handler
└──────────┬──────────┘
           ▼
┌─────────────────────┐
│  cowboy_handler      │  ← Built-in: calls handler:init/2
└──────────┬──────────┘
           ▼
     Handler init/2
     (auth check is per-handler, not global middleware)
```

### CORS Middleware

```erlang
-module(freeapi_mw_cors).
-behaviour(cowboy_middleware).
-export([execute/2]).

execute(Req0, Env) ->
    Req = cowboy_req:set_resp_headers(#{
        <<"access-control-allow-origin">> => <<"*">>,
        <<"access-control-allow-methods">> => <<"GET, POST, PUT, PATCH, DELETE, OPTIONS">>,
        <<"access-control-allow-headers">> => <<"content-type, authorization">>
    }, Req0),
    case cowboy_req:method(Req) of
        <<"OPTIONS">> ->
            Req2 = cowboy_req:reply(204, Req),
            {stop, Req2};
        _ ->
            {ok, Req, Env}
    end.
```

### Auth Helper (Called in-handler)

```erlang
-module(freeapi_mw_auth).
-export([require/1, require_admin/1, optional/1]).

require(Req) ->
    case extract_token(Req) of
        {ok, Token} ->
            case auth_service:verify_access_token(Token) of
                {ok, Claims} -> {ok, Claims, Req};
                {error, _Reason} -> {error, response:error(Req, 401, <<"Invalid token">>)}
            end;
        error ->
            {error, response:error(Req, 401, <<"Missing authorization header">>)}
    end.

require_admin(Req) ->
    case require(Req) of
        {ok, #{<<"role">> := <<"ADMIN">>} = User, Req1} -> {ok, User, Req1};
        {ok, _, Req1} -> {error, response:error(Req1, 403, <<"Admin access required">>)};
        Error -> Error
    end.
```

---

## 7. Authentication & Authorization

### JWT Token Flow

```
Register/Login
     │
     ▼
┌──────────────┐
│ auth_service │
│              │
│ 1. Validate  │
│ 2. bcrypt    │──────► accessToken  (HS256, 15 min TTL)
│ 3. Sign JWT  │──────► refreshToken (random, 7 day TTL, stored hashed in DB)
└──────────────┘
```

### Token Implementation

```erlang
%% auth_service.erl

-define(ACCESS_TTL, 900).    %% 15 minutes
-define(REFRESH_TTL, 604800). %% 7 days

generate_access_token(User) ->
    Now = erlang:system_time(second),
    Claims = #{
        <<"sub">> => maps:get(<<"_id">>, User),
        <<"username">> => maps:get(<<"username">>, User),
        <<"email">> => maps:get(<<"email">>, User),
        <<"role">> => maps:get(<<"role">>, User),
        <<"iat">> => Now,
        <<"exp">> => Now + ?ACCESS_TTL
    },
    {ok, Token} = jwt:encode(<<"HS256">>, Claims, secret()),
    Token.

generate_refresh_token() ->
    uuid:uuid_to_string(uuid:get_v4(), binary_standard).

verify_access_token(Token) ->
    case jwt:decode(Token, secret()) of
        {ok, Claims} ->
            case maps:get(<<"exp">>, Claims) > erlang:system_time(second) of
                true -> {ok, Claims};
                false -> {error, expired}
            end;
        {error, Reason} -> {error, Reason}
    end.
```

### Password Hashing

```erlang
%% user_model.erl
hash_password(Plain) ->
    {ok, Salt} = bcrypt:gen_salt(12),
    {ok, Hash} = bcrypt:hashpw(Plain, Salt),
    list_to_binary(Hash).

verify_password(Plain, Hash) ->
    {ok, Hash} =:= bcrypt:hashpw(Plain, Hash).
```

### OAuth 2.0 (Google/GitHub)

Uses `hackney` to exchange authorization codes for tokens, then fetches user profile from provider API. The handler redirects to the frontend with JWT tokens as query parameters.

---

## 8. Database Layer

### MongoDB Connection Pool

```erlang
%% freeapi_db_sup.erl — starts the poolboy pool
init([]) ->
    PoolArgs = [
        {name, {local, freeapi_db_pool}},
        {worker_module, freeapi_db_worker},
        {size, pool_size()},          %% default 10
        {max_overflow, pool_overflow()} %% default 5
    ],
    WorkerArgs = [
        {host, db_host()},
        {port, db_port()},
        {database, db_name()}
    ],
    ChildSpecs = [poolboy:child_spec(freeapi_db_pool, PoolArgs, WorkerArgs)],
    {ok, {{one_for_one, 5, 10}, ChildSpecs}}.
```

### Query Helper

```erlang
%% freeapi_db.erl
-export([find/3, find_one/3, insert/3, update/4, delete/3, count/3]).

find(Collection, Filter, Opts) ->
    poolboy:transaction(freeapi_db_pool, fun(Worker) ->
        freeapi_db_worker:find(Worker, Collection, Filter, Opts)
    end).

find_one(Collection, Filter, Opts) ->
    poolboy:transaction(freeapi_db_pool, fun(Worker) ->
        freeapi_db_worker:find_one(Worker, Collection, Filter, Opts)
    end).

%% ... insert, update, delete follow same pattern
```

### Collections

| Collection | Used By |
|---|---|
| `users` | Auth, Seed |
| `todos` | Todo App |
| `categories` | E-commerce |
| `products` | E-commerce |
| `carts` | E-commerce |
| `orders` | E-commerce |
| `coupons` | E-commerce |
| `addresses` | E-commerce |
| `ecommerce_profiles` | E-commerce |
| `social_profiles` | Social Media |
| `social_posts` | Social Media |
| `social_comments` | Social Media |
| `social_likes` | Social Media |
| `social_bookmarks` | Social Media |
| `social_follows` | Social Media |
| `chats` | Chat App |
| `chat_messages` | Chat App |

---

## 9. JSON Data (Public APIs)

### ETS-Based Cache (gen_server)

Static JSON data is loaded once at application startup into ETS tables. This gives O(1) lookups by ID and fast sequential scans for pagination/search.

```erlang
%% freeapi_json_cache.erl
-behaviour(gen_server).

%% One ETS table per resource: randomusers, randomproducts, etc.
init([]) ->
    Resources = [randomusers, randomproducts, randomjokes,
                 books, quotes, meals, dogs, cats, stocks],
    lists:foreach(fun(Name) ->
        Tab = ets:new(Name, [named_table, set, {read_concurrency, true}]),
        File = filename:join(data_dir(), atom_to_list(Name) ++ ".json"),
        {ok, Bin} = file:read_file(File),
        Items = jiffy:decode(Bin, [return_maps]),
        lists:foreach(fun(Item) ->
            Id = maps:get(<<"id">>, Item),
            ets:insert(Tab, {Id, Item})
        end, Items),
        %% Store ordered list for pagination
        ets:insert(Tab, {all_ids, [maps:get(<<"id">>, I) || I <- Items]})
    end, Resources),
    {ok, #{}}.

get_page(Resource, Page, Limit) ->
    AllIds = ets:lookup_element(Resource, all_ids, 2),
    Total = length(AllIds),
    Start = (Page - 1) * Limit + 1,
    PageIds = lists:sublist(AllIds, Start, Limit),
    Items = [ets:lookup_element(Resource, Id, 2) || Id <- PageIds],
    {Items, Total}.

get_by_id(Resource, Id) ->
    case ets:lookup(Resource, Id) of
        [{_, Item}] -> {ok, Item};
        [] -> not_found
    end.

get_random(Resource) ->
    AllIds = ets:lookup_element(Resource, all_ids, 2),
    Id = lists:nth(rand:uniform(length(AllIds)), AllIds),
    ets:lookup_element(Resource, Id, 2).
```

---

## 10. WebSocket (Chat App)

### Architecture

```
Browser ──ws──► cowboy ──► chat_ws_h (one process per client)
                               │
                               ├─ on connect: register in freeapi_chat_registry
                               ├─ on message: save via chat_model, broadcast via registry
                               └─ on disconnect: unregister, notify others
```

### Chat Registry (gen_server)

```erlang
%% freeapi_chat_registry.erl
%% State: #{ChatId => #{Pid => UserInfo}}

handle_cast({join, ChatId, Pid, UserInfo}, State) ->
    erlang:monitor(process, Pid),
    Members = maps:get(ChatId, State, #{}),
    {noreply, State#{ChatId => Members#{Pid => UserInfo}}};

handle_cast({broadcast, ChatId, SenderPid, Event}, State) ->
    Members = maps:get(ChatId, State, #{}),
    maps:foreach(fun(Pid, _) when Pid =/= SenderPid ->
        Pid ! {ws_send, Event};
    (_, _) -> ok
    end, Members),
    {noreply, State};

handle_info({'DOWN', _Ref, process, Pid, _Reason}, State) ->
    %% Remove Pid from all chats
    NewState = maps:map(fun(_ChatId, Members) ->
        maps:remove(Pid, Members)
    end, State),
    {noreply, NewState}.
```

### WebSocket Handler

```erlang
%% chat_ws_h.erl
-export([init/2, websocket_init/1, websocket_handle/2, websocket_info/2]).

init(Req, State) ->
    {cowboy_websocket, Req, State, #{idle_timeout => 300000}}.

websocket_init(State) ->
    %% Auth happens via first message or query param token
    {ok, State}.

websocket_handle({text, Json}, State) ->
    Msg = jiffy:decode(Json, [return_maps]),
    handle_event(Msg, State);

websocket_handle(_Frame, State) ->
    {ok, State}.

websocket_info({ws_send, Event}, State) ->
    Json = jiffy:encode(Event),
    {reply, {text, Json}, State}.
```

---

## 11. File Upload & Static Assets

### Multipart Upload (Cowboy)

```erlang
%% upload_service.erl
read_multipart(Req0, MaxSize) ->
    case cowboy_req:read_part(Req0) of
        {ok, Headers, Req1} ->
            case cow_multipart:form_data(Headers) of
                {file, FieldName, Filename, ContentType} ->
                    {ok, Body, Req2} = read_part_body(Req1, <<>>, MaxSize),
                    {ok, #{field => FieldName, filename => Filename,
                           content_type => ContentType, data => Body}, Req2};
                {data, FieldName} ->
                    {ok, Body, Req2} = cowboy_req:read_part_body(Req1),
                    {ok, #{field => FieldName, value => Body}, Req2}
            end;
        {done, Req1} ->
            {done, Req1}
    end.

save_file(Data, SubDir) ->
    Ext = filename:extension(maps:get(filename, Data)),
    Name = <<(uuid:uuid_to_string(uuid:get_v4(), binary_nodash))/binary, Ext/binary>>,
    Path = filename:join([upload_dir(), SubDir, Name]),
    ok = filelib:ensure_dir(Path),
    ok = file:write_file(Path, maps:get(data, Data)),
    {ok, #{url => <<"/uploads/", SubDir/binary, "/", Name/binary>>,
           local_path => Path}}.
```

### Allowed File Types & Sizes

| Upload Context | Max Size | Allowed Types |
|---|---|---|
| Avatar | 2 MB | `image/jpeg`, `image/png`, `image/webp` |
| Post images | 2 MB | `image/jpeg`, `image/png`, `image/webp` |
| Chat attachments | 10 MB | Any |

---

## 12. Configuration Management

### sys.config

```erlang
[
  {freeapi, [
    {http_port, 8080},
    {jwt_secret, <<"change-me-in-production">>},
    {jwt_access_ttl, 900},
    {jwt_refresh_ttl, 604800},
    {db_host, "localhost"},
    {db_port, 27017},
    {db_name, <<"freeapi">>},
    {db_pool_size, 10},
    {db_pool_overflow, 5},
    {upload_dir, "./uploads"},
    {google_client_id, <<"">>},
    {google_client_secret, <<"">>},
    {github_client_id, <<"">>},
    {github_client_secret, <<"">>},
    {frontend_url, <<"http://localhost:3000">>}
  ]}
].
```

### Environment Variable Override Pattern

```erlang
%% In freeapi_app:start/2
override_from_env() ->
    Mappings = [
        {"PORT", http_port, fun list_to_integer/1},
        {"JWT_SECRET", jwt_secret, fun list_to_binary/1},
        {"MONGODB_URI", db_host, fun(V) -> V end},
        {"DB_NAME", db_name, fun list_to_binary/1}
    ],
    lists:foreach(fun({EnvKey, AppKey, Transform}) ->
        case os:getenv(EnvKey) of
            false -> ok;
            Value -> application:set_env(freeapi, AppKey, Transform(Value))
        end
    end, Mappings).
```

---

## 13. Error Handling

### Standard Response Envelope

```erlang
%% response.erl
-export([success/3, paginated/6, error/3, error/4]).

success(Req, Status, Data) ->
    Body = jiffy:encode(#{
        <<"statusCode">> => Status,
        <<"data">> => Data,
        <<"message">> => status_message(Status),
        <<"success">> => true
    }),
    cowboy_req:reply(Status, #{<<"content-type">> => <<"application/json">>}, Body, Req).

error(Req, Status, Message) ->
    error(Req, Status, Message, []).

error(Req, Status, Message, Errors) ->
    Body = jiffy:encode(#{
        <<"statusCode">> => Status,
        <<"data">> => null,
        <<"message">> => Message,
        <<"success">> => false,
        <<"errors">> => Errors
    }),
    cowboy_req:reply(Status, #{<<"content-type">> => <<"application/json">>}, Body, Req).

paginated(Req, Status, Items, Page, Limit, Total) ->
    TotalPages = (Total + Limit - 1) div Limit,
    Body = jiffy:encode(#{
        <<"statusCode">> => Status,
        <<"data">> => Items,
        <<"message">> => <<"Success">>,
        <<"success">> => true,
        <<"pagination">> => #{
            <<"page">> => Page,
            <<"limit">> => Limit,
            <<"totalItems">> => Total,
            <<"totalPages">> => TotalPages,
            <<"hasNext">> => Page < TotalPages,
            <<"hasPrev">> => Page > 1
        }
    }),
    cowboy_req:reply(Status, #{<<"content-type">> => <<"application/json">>}, Body, Req).
```

### "Let It Crash" + Catch-All

Unhandled exceptions in handlers are caught by a wrapper that returns a 500 response, while the supervision tree ensures the system stays up:

```erlang
%% In each handler, or via a cowboy stream handler:
safe_init(Req0, Opts) ->
    try
        init_impl(Req0, Opts)
    catch
        Class:Reason:Stack ->
            logger:error("Handler crash: ~p:~p~n~p", [Class, Reason, Stack]),
            Req = response:error(Req0, 500, <<"Internal server error">>),
            {ok, Req, []}
    end.
```

---

## 14. Testing Strategy

| Layer | Framework | What |
|---|---|---|
| **Unit** | EUnit | Model functions, utility functions, validation |
| **Integration** | Common Test | Full HTTP request/response via `gun` or `hackney` against a running test instance |
| **Property** | PropEr | Pagination edge cases, JSON encoding roundtrips, input validation |

### Test Execution

```bash
# Run all tests
rebar3 ct

# Run specific suite
rebar3 ct --suite=auth_SUITE

# Run EUnit tests
rebar3 eunit

# Run with coverage
rebar3 cover
```

### Integration Test Pattern

```erlang
%% auth_SUITE.erl
register_and_login(_Config) ->
    %% Register
    {ok, 201, _, RegBody} = http_post("/api/v1/users/register", #{
        <<"username">> => <<"testuser">>,
        <<"email">> => <<"test@example.com">>,
        <<"password">> => <<"password123">>
    }),
    #{<<"data">> := #{<<"accessToken">> := Token}} = jiffy:decode(RegBody, [return_maps]),
    
    %% Get current user with token
    {ok, 200, _, UserBody} = http_get("/api/v1/users/current-user", Token),
    #{<<"data">> := #{<<"username">> := <<"testuser">>}} = jiffy:decode(UserBody, [return_maps]),
    ok.
```

---

## 15. Build, Release & Deployment

### rebar.config (Key Sections)

```erlang
{erl_opts, [debug_info, warnings_as_errors]}.

{deps, [
    {cowboy, "2.12.0"},
    {jiffy, "1.1.2"},
    {mongodb, "3.5.1"},
    {poolboy, "1.5.2"},
    {jwt, "0.1.11"},
    {bcrypt, "1.2.2"},
    {uuid, "2.0.7"},
    {hackney, "1.20.1"},
    {qdate, "0.7.0"}
]}.

{relx, [
    {release, {freeapi, "0.1.0"}, [freeapi, sasl]},
    {mode, dev},
    {sys_config, "./config/sys.config"},
    {vm_args, "./config/vm.args"},
    {extended_start_script, true}
]}.

{profiles, [
    {prod, [
        {relx, [{mode, prod}, {include_erts, true}]}
    ]},
    {test, [
        {deps, [{proper, "1.4.0"}, {gun, "2.1.0"}]}
    ]}
]}.
```

### vm.args

```
-name freeapi@127.0.0.1
-setcookie freeapi_secret_cookie
+P 1000000
+K true
+A 64
+SDio 64
```

| Flag | Purpose |
|---|---|
| `+P 1000000` | Max processes — needed for high concurrency (WS connections) |
| `+K true` | Enable kernel poll (epoll/kqueue) for efficient I/O |
| `+A 64` | Async thread pool size for file I/O |
| `+SDio 64` | Dirty I/O schedulers for NIF-heavy operations (jiffy, bcrypt) |

### Docker

```dockerfile
FROM erlang:27-alpine AS builder
WORKDIR /app
COPY . .
RUN rebar3 as prod release

FROM alpine:3.20
RUN apk add --no-cache openssl ncurses-libs libstdc++
COPY --from=builder /app/_build/prod/rel/freeapi /app
EXPOSE 8080
CMD ["/app/bin/freeapi", "foreground"]
```

### Build Commands

```bash
# Compile
rebar3 compile

# Run in dev (interactive shell)
rebar3 shell

# Build release
rebar3 as prod release

# Run release
_build/prod/rel/freeapi/bin/freeapi foreground
```

---

## 16. Library Reference

| Package | Version | Hex URL | Purpose |
|---|---|---|---|
| `cowboy` | 2.12.x | https://hex.pm/packages/cowboy | HTTP/WS server |
| `cowlib` | 2.13.x | (dep of cowboy) | HTTP protocol utilities |
| `ranch` | 2.1.x | (dep of cowboy) | TCP acceptor pool |
| `jiffy` | 1.1.x | https://hex.pm/packages/jiffy | JSON NIF codec |
| `mongodb` | 3.5.x | https://hex.pm/packages/mongodb | MongoDB driver |
| `poolboy` | 1.5.x | https://hex.pm/packages/poolboy | Worker pool |
| `jwt` | 0.1.x | https://hex.pm/packages/jwt | JWT encode/decode |
| `bcrypt` | 1.2.x | https://hex.pm/packages/bcrypt | Password hashing |
| `uuid` | 2.0.x | https://hex.pm/packages/uuid | UUID v4 generation |
| `hackney` | 1.20.x | https://hex.pm/packages/hackney | HTTP client (OAuth) |
| `qdate` | 0.7.x | https://hex.pm/packages/qdate | Date/time utils |
| `gen_smtp` | 1.2.x | https://hex.pm/packages/gen_smtp | SMTP client |
| `proper` | 1.4.x | https://hex.pm/packages/proper | Property testing (test only) |
| `gun` | 2.1.x | https://hex.pm/packages/gun | HTTP client (test only) |

---

## Design Patterns Summary

| Pattern | Where Applied |
|---|---|
| **OTP Supervision** | Entire app — crash isolation, automatic restart |
| **Process-per-connection** | Cowboy HTTP + WebSocket handlers |
| **Worker Pool** | MongoDB connections via poolboy |
| **ETS Read-Optimized Cache** | Public API static data — zero-copy reads |
| **Registry Pattern** | Chat WebSocket pid tracking with monitor-based cleanup |
| **Envelope Pattern** | All JSON responses use standard `{statusCode, data, message, success}` |
| **Middleware Chain** | CORS → Router → Handler (auth is in-handler) |
| **Layered Architecture** | Handler → Model → DB (handlers never touch DB directly) |

---

**End of Architecture Blueprint**
