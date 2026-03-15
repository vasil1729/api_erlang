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

### ⚠️ Test-Driven Development (TDD) Required

**All new code must follow TDD workflow:**

1. **Write the test FIRST** — before any implementation
2. **Run the test** — watch it fail (Red phase)
3. **Write minimal code** to make the test pass (Green phase)
4. **Refactor** — improve code quality while keeping tests green
5. **Repeat** for each behavior/edge case

### TDD Workflow for Endpoints

For each endpoint, follow this order:

```
1. Write failing Common Test suite
   └─► Define expected request/response
   └─► Define edge cases (400, 401, 404, etc.)

2. Implement minimal handler code
   └─► Add route to router
   └─► Implement handler action clause
   └─► Return hardcoded response

3. Run test — verify it passes

4. Implement actual logic
   └─► Add model layer (if DB-backed)
   └─► Add service layer (if complex logic)
   └─► Refactor while tests stay green

5. Add more tests for edge cases
   └─► Invalid input (400)
   └─► Missing auth (401)
   └─► Not found (404)
   └─► Forbidden (403)
```

### Example TDD Flow: Implementing `GET /api/v1/public/randomusers`

**Step 1 — Write the test first** (`test/public_api_SUITE.erl`):
```erlang
get_randomusers_returns_paginated_list(_Config) ->
    %% Arrange
    ExpectedStatus = 200,
    
    %% Act
    {ok, {{_, ExpectedStatus, _}, _Headers, Body}} = 
        httpc:request(get, {"http://localhost:8080/api/v1/public/randomusers", []}, [], []),
    
    %% Assert
    #{<<"statusCode">> := ExpectedStatus, 
      <<"data">> := Data,
      <<"success">> := true} = jiffy:decode(Body, [return_maps]),
    true = is_list(Data),
    10 = length(Data).  %% Default limit
```

**Step 2 — Run test (expect failure)**:
```bash
rebar3 ct --suite=public_api_SUITE
% FAIL: Function clause not found or endpoint not routed
```

**Step 3 — Implement minimal handler**:
```erlang
%% In handlers/public/randomuser_h.erl
init(Req0, [list]) ->
    Items = [],  %% TODO: load from ETS
    Req = response:success(Req0, 200, Items),
    {ok, Req, []}.
```

**Step 4 — Run test again (should pass)**:
```bash
rebar3 ct --suite=public_api_SUITE
% PASS
```

**Step 5 — Refactor with actual implementation**:
```erlang
init(Req0, [list]) ->
    {Page, Limit} = pagination:parse_query(Req0),
    {Items, Total} = freeapi_json_cache:get_page(randomusers, Page, Limit),
    Req = response:paginated(Req0, 200, Items, Page, Limit, Total),
    {ok, Req, []}.
```

**Step 6 — Add more tests** for edge cases:
- Invalid page/limit parameters
- Out-of-range page numbers
- Search/filter functionality

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

# Run tests during development (after each change)
rebar3 ct --watch  # If available, or manually re-run
```

### TDD Checklist for Each Endpoint

- [ ] Read endpoint spec in `API_SPEC.md`
- [ ] Write test for happy path (200/201 response)
- [ ] Write test for each error case (400, 401, 403, 404)
- [ ] Run tests — all should fail
- [ ] Implement minimal code to pass happy path test
- [ ] Run tests — happy path passes
- [ ] Implement error handling
- [ ] Run tests — all pass
- [ ] Refactor (extract functions, improve naming)
- [ ] Run tests — still all pass
- [ ] Commit with test + implementation together

---

### ⚠️ One Commit Per API Endpoint

**Rule**: Each API endpoint implementation must be a single, atomic commit containing:

1. **Integration tests** (Common Test suite or new test function)
2. **Unit tests** (EUnit tests for helper functions, validators, models)
3. **Handler implementation**
4. **Model/Service layer** (if applicable)
5. **Route registration** (if new endpoint)

**Example commit structure:**
```
feat: implement GET /api/v1/public/randomusers

Tests:
- Add integration test in public_api_SUITE.erl
- Add unit tests for pagination helpers

Implementation:
- Add route to freeapi_router.erl
- Implement randomuser_h:init/2 with [list] action
- Use freeapi_json_cache:get_page/3 for ETS lookup

Verification:
- rebar3 ct --suite=public_api_SUITE  ✓ PASS
- rebar3 ct                           ✓ PASS
```

**Why atomic commits?**
- Easy to review and understand
- Simple to revert if issues arise
- Clear git history for each endpoint
- Enables bisect for debugging

**What NOT to do:**
❌ Commit tests separately from implementation
❌ Bundle multiple endpoints in one commit
❌ Commit implementation without tests
❌ Add unrelated refactoring in endpoint commits

---

### ⚠️ Both Integration and Unit Tests Required

**Every endpoint must have:**

#### 1. Integration Tests (Common Test)
Location: `apps/freeapi/test/<category>_SUITE.erl`

Tests the full HTTP request/response cycle:
```erlang
%% Integration test - tests the entire stack
get_randomusers_returns_paginated_list(_Config) ->
    {ok, {{_, 200, _}, _Headers, Body}} = 
        httpc:request(get, {"http://localhost:8080/api/v1/public/randomusers", []}, [], []),
    #{<<"statusCode">> := 200, <<"data">> := Data} = jiffy:decode(Body, [return_maps]),
    true = is_list(Data),
    10 = length(Data).
```

**Coverage:**
- Happy path (200/201)
- All error cases (400, 401, 403, 404)
- Edge cases (invalid params, missing headers)
- Auth requirements (if applicable)

#### 2. Unit Tests (EUnit)
Location: Same file as the module being tested (`*_test.erl` or inline `-ifdef(TEST)`)

Tests individual functions in isolation:
```erlang
%% Unit tests for pagination.erl
-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").

parse_query_default_test() ->
    %% Mock request with no query params
    Req = mock_request_with_query(<<>>),
    {1, 10} = pagination:parse_query(Req).

parse_query_custom_page_limit_test() ->
    Req = mock_request_with_query(<<"page=5&limit=20">>),
    {5, 20} = pagination:parse_query(Req).

parse_query_invalid_page_test() ->
    Req = mock_request_with_query(<<"page=abc">>),
    {1, 10} = pagination:parse_query(Req).  %% Falls back to default
-endif.
```

**Coverage:**
- Helper functions (`utils/`)
- Model CRUD operations
- Service layer logic
- Validator functions
- Edge cases and boundary conditions

#### Test File Organization

```
apps/freeapi/test/
├── healthcheck_SUITE.erl          # Common Test integration
├── public_api_SUITE.erl           # Common Test integration
├── auth_SUITE.erl                 # Common Test integration
├── todo_SUITE.erl                 # Common Test integration
├── ecommerce_SUITE.erl            # Common Test integration
├── social_media_SUITE.erl         # Common Test integration
├── chat_SUITE.erl                 # Common Test integration
└── kitchen_sink_SUITE.erl         # Common Test integration

apps/freeapi/src/
├── utils/
│   ├── pagination.erl
│   ├── pagination_test.erl        # EUnit tests (separate file)
│   ├── validator.erl
│   └── validator_test.erl         # EUnit tests (separate file)
├── models/
│   ├── user_model.erl
│   └── user_model_test.erl        # EUnit tests for model functions
└── handlers/
    └── *_h.erl                    # May include -ifdef(TEST) blocks
```

#### Running All Tests

```bash
# Run integration tests (Common Test)
rebar3 ct

# Run unit tests (EUnit)
rebar3 eunit

# Run all tests
rebar3 do eunit, ct

# Run with coverage
rebar3 cover
```

#### Pre-Commit Checklist

Before committing an endpoint implementation:

- [ ] Integration test(s) written and passing
- [ ] Unit test(s) for new functions written and passing
- [ ] `rebar3 do eunit, ct` passes completely
- [ ] No test warnings or skip reasons
- [ ] Commit message describes the endpoint + tests

---

### ⚠️ Track Progress in API_SPEC.md

**Rule**: Use `API_SPEC.md` as the single source of truth for implementation progress.

#### Before Implementing Any Endpoint

1. **Check the current status** in `API_SPEC.md`
2. **Look for the checkbox** next to the endpoint
3. **Verify it's not already implemented**

#### After Completing an Endpoint

1. **Update the checkbox** in `API_SPEC.md` with ✅
2. **Add a note** with the commit hash
3. **Commit the API_SPEC.md change** with the implementation

#### Checkbox Format

In `API_SPEC.md`, each endpoint has a checkbox:

```markdown
### 2.1 Random Users

- [ ] `GET /api/v1/public/randomusers`
- [ ] `GET /api/v1/public/randomusers/:userId`
- [ ] `GET /api/v1/public/randomusers/user/random`
```

After implementation:

```markdown
### 2.1 Random Users

- [x] `GET /api/v1/public/randomusers` ✅ (commit: abc1234)
- [ ] `GET /api/v1/public/randomusers/:userId`
- [ ] `GET /api/v1/public/randomusers/user/random`
```

#### Progress Tracking Commands

```bash
# Count implemented endpoints
grep -c "\[x\]" API_SPEC.md

# Count remaining endpoints
grep -c "\[ \]" API_SPEC.md

# Calculate completion percentage
total=$(grep -c "GET\|POST\|PUT\|PATCH\|DELETE" API_SPEC.md)
done=$(grep -c "\[x\]" API_SPEC.md)
echo "Progress: $done/$total ($(($done * 100 / $total))%)"
```

#### Why Track in API_SPEC.md?

- ✅ **Single source of truth** — no separate tracking files
- ✅ **Git history** — commits show what was implemented when
- ✅ **Easy to scan** — see progress at a glance
- ✅ **Motivation** — watch the ✅ count grow
- ✅ **Accountability** — clear what's done vs. pending

#### What NOT to Do

❌ Don't track progress in separate files (TODO.md, PROGRESS.md, etc.)
❌ Don't update checkboxes without committing the implementation
❌ Don't mark as done until all tests pass
❌ Don't bundle multiple endpoint checkboxes in one commit

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
