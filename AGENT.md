# Agent Guidelines — FreeAPI Erlang/OTP Codebase

This document provides instructions for AI agents navigating and working with this Erlang/OTP implementation of FreeAPI Hub (168 REST endpoints).

---

## Project Overview

**Goal**: Implement the complete [FreeAPI Hub](https://freeapi.app) specification in idiomatic Erlang/OTP.

**Scope**: 168 REST endpoints across 9 categories + WebSocket support for real-time chat.

**Tech Stack**:
- **HTTP Server**: Cowboy 2.x
- **JSON**: jiffy (NIF-based)
- **Database**: MongoDB via mongodb-erlang + poolboy
- **JWT**: jwt library (HS256)
- **Password Hashing**: bcrypt
- **Build**: rebar3

---

## Key Files & Directories

| Path | Purpose |
|------|---------|
| `API_SPEC.md` | **Source of truth** — Complete 168-endpoint specification with schemas, auth requirements, and logic |
| `ARCHITECTURE.md` | Architecture blueprint — OTP supervision tree, handler patterns, DB layer, WebSocket design |
| `README.md` | Project overview, quick start, configuration |
| `rebar.config` | Dependencies, plugins, release configuration |
| `config/sys.config` | Application environment (ports, secrets, DB config) |
| `config/vm.args` | BEAM VM flags |
| `apps/freeapi/src/` | All source code |
| `apps/freeapi/priv/data/` | Static JSON data for Public APIs |
| `apps/freeapi/test/` | Common Test suites |

---

## Source Code Structure

```
apps/freeapi/src/
├── freeapi_app.erl              # OTP application behaviour (start/stop)
├── freeapi_sup.erl              # Top-level supervisor
├── freeapi_json_cache.erl       # gen_server: ETS cache for static JSON
├── freeapi_chat_registry.erl    # gen_server: WebSocket PID registry
│
├── router/
│   └── freeapi_router.erl       # Cowboy dispatch table (168 routes)
│
├── middleware/
│   ├── freeapi_mw_cors.erl      # CORS headers
│   ├── freeapi_mw_auth.erl      # JWT verification helper
│   └── freeapi_mw_ratelimit.erl # Rate limiting
│
├── handlers/                    # Cowboy request handlers
│   ├── healthcheck_h.erl
│   ├── public/                  # 10 public API handlers (read-only)
│   ├── auth/                    # 16 auth endpoints
│   ├── todo/                    # 7 todo endpoints
│   ├── ecommerce/               # 40 e-commerce endpoints
│   ├── social_media/            # 24 social media endpoints
│   ├── chat/                    # 14 chat endpoints + WebSocket
│   ├── kitchen_sink/            # 27 kitchen sink endpoints
│   └── seed/                    # 5 seeding endpoints
│
├── models/                      # MongoDB CRUD operations (17 models)
├── services/                    # Business logic (auth, email, upload, seed)
├── db/                          # DB pool + query helpers
└── utils/                       # Response envelope, pagination, validation
```

---

## Coding Conventions

### Module Naming
- **Handlers**: `<resource>_h.erl` (e.g., `user_h.erl`, `randomuser_h.erl`)
- **Models**: `<resource>_model.erl` (e.g., `user_model.erl`)
- **Services**: `<service>_service.erl` (e.g., `auth_service.erl`)
- **Middleware**: `freeapi_mw_<name>.erl` (e.g., `freeapi_mw_cors.erl`)
- **Utils**: `<purpose>.erl` (e.g., `response.erl`, `pagination.erl`)

### Function Naming in Handlers
Handlers use an action atom passed via `Opts` to determine behavior:

```erlang
init(Req0, [list]) ->      % GET /resource
init(Req0, [get_one]) ->   % GET /resource/:id
init(Req0, [create]) ->    % POST /resource
init(Req0, [update]) ->    % PUT/PATCH /resource/:id
init(Req0, [delete]) ->    % DELETE /resource/:id
init(Req0, [random]) ->    % GET /resource/random
```

### Response Envelope
All responses follow this structure:

```erlang
#{
  <<"statusCode">> => 200,
  <<"data">> => Data,
  <<"message">> => <<"Success">>,
  <<"success">> => true
}
```

Use `response:success/3` and `response:error/3` helpers from `utils/response.erl`.

### Authentication Pattern
```erlang
init(Req0, [Action]) ->
    case freeapi_mw_auth:require(Req0) of
        {ok, User, Req1} ->
            %% Authenticated: proceed with action
            handle_authenticated(Req1, User, Action);
        {error, Req1} ->
            {ok, Req1, []}
    end.
```

For admin-only endpoints:
```erlang
case freeapi_mw_auth:require_admin(Req0) of
    {ok, Admin, Req1} -> ...;
    {error, Req1} -> ...  % 403 Forbidden
end.
```

### Database Pattern
```erlang
%% Use poolboy transaction for DB operations
Result = poolboy:transaction(freeapi_db_pool, fun(Worker) ->
    freeapi_db_worker:find_one(Worker, users, #{<<"_id">> => UserId}, [])
end).
```

### Static JSON Data Pattern
Public API data is cached in ETS via `freeapi_json_cache`:

```erlang
%% Get paginated list
{Items, Total} = freeapi_json_cache:get_page(randomusers, Page, Limit).

%% Get by ID
case freeapi_json_cache:get_by_id(randomusers, UserId) of
    {ok, Item} -> ...;
    not_found -> ...
end.

%% Get random item
Item = freeapi_json_cache:get_random(randomusers).
```

---

## Implementation Guidelines

### 1. Always Reference API_SPEC.md
Before implementing any endpoint:
1. Read the exact specification in `API_SPEC.md`
2. Note the auth requirement (None / Bearer JWT / Admin)
3. Note input validation rules
4. Note the exact response schema
5. Implement the logic as described

### 2. Follow OTP Best Practices
- Use supervision trees with appropriate restart strategies
- Prefer `one_for_one` for independent components
- Use `gen_server` for stateful processes (cache, registry)
- Let processes crash and let supervisors restart them

### 3. Handler Implementation Order
For each endpoint category:
1. Implement the handler module with all actions
2. Add routes to `freeapi_router.erl`
3. Implement the model layer (if DB-backed)
4. Implement service layer (if complex logic)
5. Write tests in `test/`

### 4. Error Handling
- Return appropriate HTTP status codes (400, 401, 403, 404, 500)
- Use the error response envelope format
- Log errors with `logger:error/2`
- Never expose internal errors to clients

### 5. Input Validation
- Validate all user input in handlers
- Use `utils/validator.erl` helpers
- Return 400 Bad Request with field-level errors

### 6. JWT Token Handling
- Access token: 15 min TTL, HS256 signed
- Refresh token: 7 day TTL, stored hashed in DB
- Always verify tokens with `auth_service:verify_access_token/1`
- Extract user from JWT claims (sub = user ID)

---

## Testing Guidelines

### Test Structure
```
apps/freeapi/test/
├── healthcheck_SUITE.erl
├── public_api_SUITE.erl
├── auth_SUITE.erl
├── todo_SUITE.erl
├── ecommerce_SUITE.erl
├── social_media_SUITE.erl
├── chat_SUITE.erl
└── kitchen_sink_SUITE.erl
```

### Test Patterns
- Use **Common Test** (`*__SUITE.erl`) for integration tests
- Use **EUnit** for unit tests of individual functions
- Use **PropEr** for property-based testing of validators

### Running Tests
```bash
# All tests
rebar3 ct

# Specific suite
rebar3 ct --suite=auth_SUITE

# With coverage
rebar3 cover
```

---

## Navigation Tips

### Finding an Endpoint Implementation
1. Look up the endpoint in `API_SPEC.md`
2. Note the category (public, auth, todo, etc.)
3. Find the handler in `apps/freeapi/src/handlers/<category>/`
4. Check the route in `apps/freeapi/src/router/freeapi_router.erl`

### Understanding Data Flow
```
Request → CORS MW → Router → Handler → Model → DB
                              ↓
                         Service (if needed)
                              ↓
                         Response envelope → JSON → Client
```

### WebSocket Flow
```
Browser → cowboy → chat_ws_h → freeapi_chat_registry
                                    ↓
                              Broadcast to PIDs
```

---

## Common Tasks

### Adding a New Endpoint
1. Add route to `freeapi_router.erl`
2. Create/update handler in `handlers/<category>/`
3. Implement action clause in `init/2`
4. Add model functions if DB-backed
5. Add tests
6. Update `API_SPEC.md` if spec changed

### Implementing Auth-Required Endpoint
```erlang
init(Req0, [Action]) ->
    case freeapi_mw_auth:require(Req0) of
        {ok, #{<<"sub">> := UserId} = User, Req1} ->
            %% UserId is the MongoDB _id
            Body = cowboy_req:read_body(Req1),
            Result = some_model:create(UserId, Body),
            Req = response:success(Req1, 201, Result),
            {ok, Req, []};
        {error, Req1} ->
            {ok, Req1, []}
    end.
```

### Working with Static JSON
```erlang
%% In handler init:
init(Req0, [list]) ->
    {Page, Limit} = pagination:parse_query(Req0),
    {Items, Total} = freeapi_json_cache:get_page(randomusers, Page, Limit),
    Req = response:paginated(Req0, 200, Items, Page, Limit, Total),
    {ok, Req, []}.
```

---

## Environment Variables

| Variable | Config Key | Default | Description |
|----------|-----------|---------|-------------|
| `PORT` | `http_port` | `8080` | HTTP listen port |
| `JWT_SECRET` | `jwt_secret` | `"change-me"` | JWT signing secret |
| `MONGODB_URI` | `db_host` | `"localhost"` | MongoDB host |
| `DB_NAME` | `db_name` | `freeapi` | Database name |
| `GOOGLE_CLIENT_ID` | `google_client_id` | — | OAuth Google |
| `GITHUB_CLIENT_ID` | `github_client_id` | — | OAuth GitHub |
| `FRONTEND_URL` | `frontend_url` | `localhost:3000` | OAuth redirect |

---

## Quick Reference

### Build & Run
```bash
rebar3 compile          # Compile
rebar3 shell            # Start shell
rebar3 ct               # Run tests
rebar3 as prod release  # Build release
```

### Docker
```bash
docker-compose up       # Start with MongoDB
```

### Key Modules to Know
| Module | Purpose |
|--------|---------|
| `response.erl` | Build standard JSON responses |
| `pagination.erl` | Parse query params, build pagination envelope |
| `validator.erl` | Input validation helpers |
| `crypto_util.erl` | SHA256 hashing, random token generation |
| `auth_service.erl` | JWT issue/verify, OAuth flows |
| `freeapi_json_cache.erl` | ETS cache for static JSON data |
| `freeapi_chat_registry.erl` | Track WebSocket PIDs per chat room |

---

## Current Implementation Status

**Completed**:
- ✅ Project structure scaffolded (all directories and module files)
- ✅ API specification (`API_SPEC.md`)
- ✅ Architecture blueprint (`ARCHITECTURE.md`)
- ✅ README with quick start guide
- ✅ Core application modules (stubbed)

**In Progress / TODO**:
- ⏳ Handler implementations (all are TODO stubs)
- ⏳ Model/database layers
- ⏳ Service layer implementations
- ⏳ Router dispatch table (needs full route definitions)
- ⏳ Middleware implementations
- ⏳ Database connection pool
- ⏳ ETS cache initialization
- ⏳ WebSocket handlers
- ⏳ Test suites

**Priority Order for Implementation**:
1. Healthcheck endpoint (simplest, verifies setup)
2. Public APIs (read-only, uses ETS cache)
3. Auth module (foundation for protected endpoints)
4. Todo app (simple CRUD with auth)
5. E-commerce, Social Media, Chat (complex, interdependent)
6. Kitchen Sink (utility endpoints)
7. Seeding (populates test data)

---

## Anti-Patterns to Avoid

❌ **Don't** bypass the response envelope helpers — always use `response:success/3` and `response:error/3`

❌ **Don't** access MongoDB directly — always use `poolboy:transaction/2` with `freeapi_db_pool`

❌ **Don't** store plain text passwords — always use `bcrypt:hashpw/2`

❌ **Don't** log sensitive data (passwords, tokens, PII)

❌ **Don't** implement auth logic in handlers — use `freeapi_mw_auth` helpers

❌ **Don't** hardcode configuration — use `application:get_env/2` or `application:get_env/3`

❌ **Don't** ignore return values — pattern match and handle all cases

---

## Questions to Ask Before Implementing

1. What is the exact endpoint specification in `API_SPEC.md`?
2. What authentication is required (None / Bearer / Admin)?
3. What are the input validation rules?
4. What is the exact response schema?
5. Does this endpoint need database access or static JSON?
6. Are there existing tests I should update or extend?
7. Does this endpoint share logic with existing services?

---

## Contact & Resources

- **FreeAPI Specification**: https://freeapi.app
- **Cowboy Documentation**: https://ninenines.eu/docs/en/cowboy/2.10/
- **Erlang/OTP Docs**: https://www.erlang.org/doc/
- **rebar3 Docs**: https://rebar3.org/docs/
