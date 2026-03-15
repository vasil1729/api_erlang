# FreeAPI Hub — Erlang/OTP

A complete implementation of the [FreeAPI Hub](https://freeapi.app) in Erlang/OTP — 168 REST endpoints spanning 9 categories, built on Cowboy, MongoDB, and OTP supervision trees.

## What is FreeAPI?

FreeAPI provides a suite of free, ready-to-consume APIs for frontend developers and learners to practice building real-world applications against. This project re-implements the entire backend in idiomatic Erlang.

## API Categories

| Category | Endpoints | Description |
|---|---|---|
| 📢 Public APIs | 34 | Users, products, jokes, books, quotes, meals, dogs, cats, stocks, YouTube |
| 🔐 Authentication | 16 | Register, login, JWT, OAuth (Google/GitHub), email verification, password reset |
| 📝 Todo App | 7 | CRUD + toggle status with ownership |
| 🛒 E-commerce | 40 | Products, categories, cart, orders (Razorpay/PayPal), coupons, addresses, profiles |
| 📸 Social Media | 24 | Posts, comments, likes, bookmarks, follows, profiles |
| 💬 Chat App | 14 | 1-on-1 & group chats, messages, WebSocket real-time |
| 🚰 Kitchen Sink | 27 | HTTP methods, status codes, headers, cookies, redirects, images, compression |
| 💉 Seeding | 5 | Seed test data for all modules |
| ⛑️ Healthcheck | 1 | Server status |
| **Total** | **168** | |

## Tech Stack

| Concern | Library |
|---|---|
| HTTP Server | [Cowboy 2.x](https://github.com/ninenines/cowboy) |
| JSON | [jiffy](https://github.com/davisp/jiffy) (NIF) |
| Database | [mongodb-erlang](https://github.com/comtihon/mongodb-erlang) + [poolboy](https://github.com/devinus/poolboy) |
| JWT | [jwt](https://github.com/artemeff/jwt) |
| Password Hashing | [bcrypt](https://hex.pm/packages/bcrypt) |
| HTTP Client | [hackney](https://github.com/benoitc/hackney) (OAuth) |
| Build | [rebar3](https://rebar3.org) |
| Testing | Common Test + EUnit + [PropEr](https://github.com/proper-testing/proper) |

## Project Structure

```
api_erlang/
├── config/                          # sys.config, vm.args
├── apps/freeapi/
│   ├── src/
│   │   ├── freeapi_app.erl          # OTP application
│   │   ├── freeapi_sup.erl          # Top-level supervisor
│   │   ├── router/                  # Cowboy dispatch table (168 routes)
│   │   ├── middleware/              # CORS, auth, rate limiting
│   │   ├── handlers/               # Request handlers by category
│   │   │   ├── public/             #   10 public API handlers
│   │   │   ├── auth/               #   User auth handler (16 actions)
│   │   │   ├── todo/               #   Todo CRUD handler
│   │   │   ├── ecommerce/          #   7 e-commerce handlers
│   │   │   ├── social_media/       #   6 social media handlers
│   │   │   ├── chat/               #   Chat + messages + WebSocket
│   │   │   ├── kitchen_sink/       #   7 kitchen sink handlers
│   │   │   └── seed/               #   Database seeding handler
│   │   ├── models/                  # 17 data models (MongoDB CRUD)
│   │   ├── services/               # Auth, email, upload, seed logic
│   │   ├── db/                     # Connection pool + query helpers
│   │   └── utils/                  # Response envelope, pagination, validation
│   ├── priv/                        # Static data, images, templates
│   └── test/                        # 8 Common Test suites
├── rebar.config
├── Dockerfile
├── docker-compose.yml
├── API_SPEC.md                      # Full 168-endpoint specification
└── ARCHITECTURE.md                  # Detailed architecture blueprint
```

## Quick Start

### Prerequisites

- Erlang/OTP 27+ (tested on OTP 28)
- rebar3 (install: `curl -O https://s3.amazonaws.com/rebar3/rebar3 && chmod +x rebar3 && mv rebar3 ~/bin/`)
- MongoDB 7+
- Docker (optional, for MongoDB)

### Run locally

```bash
# Start MongoDB (using Docker)
docker run -d --name freeapi-mongo -p 27017:27017 mongo:7

# Or install MongoDB locally and run:
# mongod --dbpath /tmp/freeapi-data

# Compile (note: qdate removed due to Erlang 28 incompatibility)
rebar3 compile

# Run in development shell
rebar3 shell

# Or build a production release and run
rebar3 as prod release
_build/prod/rel/freeapi/bin/freeapi foreground
```

The API will be available at `http://localhost:8080`.

### Run with Docker

```bash
docker-compose up --build
```

Note: The Docker build may take a while. For faster development, use the local setup above.

### Verify installation

```bash
curl http://localhost:8080/api/v1/healthcheck
# Expected: {"success":true,"statusCode":200,"message":"OK","data":null}
```

## Configuration

Environment variables (override `config/sys.config`):

| Variable | Default | Description |
|---|---|---|
| `PORT` | `8080` | HTTP listen port |
| `JWT_SECRET` | `change-me-in-production` | JWT signing secret |
| `MONGODB_URI` | `localhost` | MongoDB host |
| `DB_NAME` | `freeapi` | MongoDB database name |
| `GOOGLE_CLIENT_ID` | — | Google OAuth client ID |
| `GOOGLE_CLIENT_SECRET` | — | Google OAuth client secret |
| `GITHUB_CLIENT_ID` | — | GitHub OAuth client ID |
| `GITHUB_CLIENT_SECRET` | — | GitHub OAuth client secret |
| `FRONTEND_URL` | `http://localhost:3000` | Frontend URL for OAuth redirects |

## Testing

```bash
# All tests
rebar3 ct

# Specific suite
rebar3 ct --suite=auth_SUITE

# With coverage
rebar3 cover
```

## Docs

- **[API_SPEC.md](API_SPEC.md)** — Complete endpoint specification with schemas, auth requirements, and logic
- **[ARCHITECTURE.md](ARCHITECTURE.md)** — Architecture blueprint: OTP supervision tree, handler patterns, DB layer, WebSocket design, library choices

## License

MIT
