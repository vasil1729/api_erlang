# FreeAPI Hub — Language-Agnostic API Specification

> **Purpose**: This document provides a complete, language-agnostic API specification. Each endpoint is described with the precision of an OpenAPI spec, enabling implementation in any programming language.
>
> **Scope**: 168 API endpoints across 9 categories.

---

## Table of Contents

1. [Conventions](#conventions)
2. [Healthcheck](#1-healthcheck)
3. [Public APIs](#2-public-apis)
4. [User Authentication](#3-user-authentication)
5. [Todo App](#4-todo-app)
6. [E-commerce](#5-e-commerce)
7. [Social Media](#6-social-media)
8. [Chat App](#7-chat-app)
9. [Kitchen Sink](#8-kitchen-sink)
10. [Seeding & Admin](#9-seeding--admin)

---

## Conventions

### Standard Response Envelope

All API responses follow this structure:

```json
{
  "statusCode": 200,
  "data": { ... },
  "message": "string",
  "success": true
}
```

### Paginated Response Envelope

For list endpoints with pagination:

```json
{
  "statusCode": 200,
  "data": { ... },
  "message": "string",
  "success": true,
  "pagination": {
    "page": 1,
    "limit": 10,
    "totalItems": 100,
    "totalPages": 10,
    "hasNext": true,
    "hasPrev": false
  }
}
```

### Error Response Envelope

```json
{
  "statusCode": 400,
  "data": null,
  "message": "Error description",
  "success": false,
  "errors": [
    { "field": "email", "message": "Invalid email format" }
  ]
}
```

### Authentication

- **No Auth**: Public endpoints, no authentication required
- **Bearer JWT**: Requires `Authorization: Bearer <token>` header
- **Admin Only**: Requires `role: "ADMIN"` in JWT payload

### Common Query Parameters

| Parameter | Type   | Default | Description           |
|-----------|--------|---------|-----------------------|
| `page`    | int    | 1       | Page number           |
| `limit`   | int    | 10      | Items per page (max 100) |
| `query`   | string | -       | Search/filter text    |
| `inc`     | string | -       | Comma-separated fields to include |
| `sortBy`  | string | -       | Sort field            |
| `order`   | string | `asc`   | Sort order: `asc` or `desc` |

---

## 1. Healthcheck

### 1.1 `GET /api/v1/healthcheck`

**Purpose**: Verify API is running.

- **Auth**: None
- **Input**: None
- **Output** (200):
  ```json
  {
    "statusCode": 200,
    "message": "OK",
    "success": true,
    "data": null
  }
  ```

---

## 2. Public APIs

> **Characteristics**: Read-only (GET), no authentication, data sourced from static JSON files.

### 2.1 Random Users

**Data Source**: `data/randomusers.json`

**User Object Schema**:
```json
{
  "id": "integer",
  "gender": "string (male|female)",
  "name": { "title": "string", "first": "string", "last": "string" },
  "email": "string",
  "phone": "string",
  "cell": "string",
  "nat": "string (2-letter country code)",
  "location": {
    "street": { "number": "integer", "name": "string" },
    "city": "string",
    "state": "string",
    "country": "string",
    "postcode": "string",
    "coordinates": { "latitude": "string", "longitude": "string" },
    "timezone": { "offset": "string (e.g., '+5:30')", "description": "string" }
  },
  "login": {
    "uuid": "string",
    "username": "string",
    "password": "string",
    "salt": "string",
    "md5": "string",
    "sha1": "string",
    "sha256": "string"
  },
  "dob": { "date": "ISO8601", "age": "integer" },
  "registered": { "date": "ISO8601", "age": "integer" },
  "picture": { "large": "string (URL)", "medium": "string (URL)", "thumbnail": "string (URL)" }
}
```

#### 2.1.1 `GET /api/v1/public/randomusers`

- **Auth**: None
- **Input**:
  - Query: `page` (int, default 1), `limit` (int, default 10)
- **Output** (200, paginated): Array of User Objects

#### 2.1.2 `GET /api/v1/public/randomusers/:userId`

- **Auth**: None
- **Input**:
  - Path: `userId` (int)
- **Output** (200): Single User Object
- **Error**: 404 if not found

#### 2.1.3 `GET /api/v1/public/randomusers/user/random`

- **Auth**: None
- **Input**: None
- **Output** (200): Single random User Object

---

### 2.2 Random Products

**Data Source**: `data/randomproducts.json`

**Product Object Schema**:
```json
{
  "id": "integer",
  "title": "string",
  "description": "string",
  "price": "number",
  "discountPercentage": "number",
  "rating": "number",
  "stock": "integer",
  "brand": "string",
  "category": "string",
  "thumbnail": "string (URL)",
  "images": ["string (URL)"]
}
```

#### 2.2.1 `GET /api/v1/public/randomproducts`

- **Auth**: None
- **Input**:
  - Query: `page` (int, default 1), `limit` (int, default 10), `query` (string, filter by category), `inc` (string, comma-separated fields)
- **Output** (200, paginated): Array of Product Objects

#### 2.2.2 `GET /api/v1/public/randomproducts/:productId`

- **Auth**: None
- **Input**:
  - Path: `productId` (int)
- **Output** (200): Single Product Object
- **Error**: 404 if not found

#### 2.2.3 `GET /api/v1/public/randomproducts/product/random`

- **Auth**: None
- **Input**: None
- **Output** (200): Single random Product Object

---

### 2.3 Random Jokes

**Data Source**: `data/randomjokes.json`

**Joke Object Schema**:
```json
{
  "id": "integer",
  "content": "string",
  "categories": ["string"]
}
```

#### 2.3.1 `GET /api/v1/public/randomjokes`

- **Auth**: None
- **Input**:
  - Query: `page` (int, default 1), `limit` (int, default 10), `query` (string, search in content), `inc` (string, fields to include)
- **Output** (200, paginated): Array of Joke Objects

#### 2.3.2 `GET /api/v1/public/randomjokes/:jokeId`

- **Auth**: None
- **Input**:
  - Path: `jokeId` (int)
- **Output** (200): Single Joke Object
- **Error**: 404 if not found

#### 2.3.3 `GET /api/v1/public/randomjokes/joke/random`

- **Auth**: None
- **Input**: None
- **Output** (200): Single random Joke Object

---

### 2.4 Books

**Data Source**: `data/books.json`

**Book Object Schema**:
```json
{
  "id": "integer",
  "title": "string",
  "author": "string",
  "publisher": "string",
  "pages": "integer",
  "genre": "string",
  "isbn": "string",
  "language": "string",
  "description": "string",
  "coverImage": "string (URL)",
  "publishedDate": "ISO8601"
}
```

#### 2.4.1 `GET /api/v1/public/books`

- **Auth**: None
- **Input**:
  - Query: `page` (int, default 1), `limit` (int, default 10), `query` (string, search in title), `inc` (string, fields filter)
- **Output** (200, paginated): Array of Book Objects

#### 2.4.2 `GET /api/v1/public/books/:bookId`

- **Auth**: None
- **Input**:
  - Path: `bookId` (int)
- **Output** (200): Single Book Object
- **Error**: 404 if not found

#### 2.4.3 `GET /api/v1/public/books/book/random`

- **Auth**: None
- **Input**: None
- **Output** (200): Single random Book Object

---

### 2.5 Quotes

**Data Source**: `data/quotes.json`

**Quote Object Schema**:
```json
{
  "id": "integer",
  "content": "string",
  "author": "string",
  "authorSlug": "string",
  "tags": ["string"]
}
```

#### 2.5.1 `GET /api/v1/public/quotes`

- **Auth**: None
- **Input**:
  - Query: `page` (int, default 1), `limit` (int, default 10), `query` (string, search)
- **Output** (200, paginated): Array of Quote Objects

#### 2.5.2 `GET /api/v1/public/quotes/:quoteId`

- **Auth**: None
- **Input**:
  - Path: `quoteId` (int)
- **Output** (200): Single Quote Object
- **Error**: 404 if not found

#### 2.5.3 `GET /api/v1/public/quotes/quote/random`

- **Auth**: None
- **Input**: None
- **Output** (200): Single random Quote Object

---

### 2.6 Meals

**Data Source**: `data/meals.json`

**Meal Object Schema**:
```json
{
  "id": "integer",
  "name": "string",
  "category": "string",
  "area": "string",
  "instructions": "string",
  "image": "string (URL)",
  "tags": ["string"],
  "youtubeLink": "string (URL)",
  "ingredients": ["string"],
  "measures": ["string"],
  "source": "string (URL)"
}
```

#### 2.6.1 `GET /api/v1/public/meals`

- **Auth**: None
- **Input**:
  - Query: `page` (int, default 1), `limit` (int, default 10), `query` (string)
- **Output** (200, paginated): Array of Meal Objects

#### 2.6.2 `GET /api/v1/public/meals/:mealId`

- **Auth**: None
- **Input**:
  - Path: `mealId` (int)
- **Output** (200): Single Meal Object
- **Error**: 404 if not found

#### 2.6.3 `GET /api/v1/public/meals/meal/random`

- **Auth**: None
- **Input**: None
- **Output** (200): Single random Meal Object

---

### 2.7 Dogs

**Data Source**: `data/dogs.json`

**Dog Breed Object Schema**:
```json
{
  "id": "integer",
  "name": "string",
  "bredFor": "string",
  "breedGroup": "string",
  "lifeSpan": "string",
  "temperament": "string",
  "origin": "string",
  "referenceImageId": "string",
  "image": { "id": "string", "width": "integer", "height": "integer", "url": "string (URL)" },
  "weight": { "imperial": "string", "metric": "string" },
  "height": { "imperial": "string", "metric": "string" }
}
```

#### 2.7.1 `GET /api/v1/public/dogs`

- **Auth**: None
- **Input**:
  - Query: `page` (int, default 1), `limit` (int, default 10), `query` (string)
- **Output** (200, paginated): Array of Dog Breed Objects

#### 2.7.2 `GET /api/v1/public/dogs/:dogId`

- **Auth**: None
- **Input**:
  - Path: `dogId` (int)
- **Output** (200): Single Dog Breed Object
- **Error**: 404 if not found

#### 2.7.3 `GET /api/v1/public/dogs/dog/random`

- **Auth**: None
- **Input**: None
- **Output** (200): Single random Dog Breed Object

---

### 2.8 Cats

**Data Source**: `data/cats.json`

**Cat Breed Object Schema**:
```json
{
  "id": "integer",
  "name": "string",
  "origin": "string",
  "temperament": "string",
  "description": "string",
  "lifeSpan": "string",
  "indoor": "boolean",
  "lap": "boolean",
  "adaptability": "integer (1-5)",
  "affectionLevel": "integer (1-5)",
  "childFriendly": "integer (1-5)",
  "dogFriendly": "integer (1-5)",
  "energyLevel": "integer (1-5)",
  "grooming": "integer (1-5)",
  "healthIssues": "integer (1-5)",
  "intelligence": "integer (1-5)",
  "sheddingLevel": "integer (1-5)",
  "socialNeeds": "integer (1-5)",
  "strangerFriendly": "integer (1-5)",
  "vocalisation": "integer (1-5)",
  "image": { "id": "string", "width": "integer", "height": "integer", "url": "string (URL)" },
  "weight": { "imperial": "string", "metric": "string" }
}
```

#### 2.8.1 `GET /api/v1/public/cats`

- **Auth**: None
- **Input**:
  - Query: `page` (int, default 1), `limit` (int, default 10), `query` (string)
- **Output** (200, paginated): Array of Cat Breed Objects

#### 2.8.2 `GET /api/v1/public/cats/:catId`

- **Auth**: None
- **Input**:
  - Path: `catId` (int)
- **Output** (200): Single Cat Breed Object
- **Error**: 404 if not found

#### 2.8.3 `GET /api/v1/public/cats/cat/random`

- **Auth**: None
- **Input**: None
- **Output** (200): Single random Cat Breed Object

---

### 2.9 Stocks

**Data Source**: `data/stocks.json`

**Stock Object Schema**:
```json
{
  "Symbol": "string",
  "Name": "string",
  "Industry": "string",
  "MarketCap": "number",
  "Price": "number",
  "Change": "number",
  "ChangePercent": "number",
  "Volume": "number",
  "AvgVolume": "number",
  "PERatio": "number",
  "EPS": "number",
  "DividendYield": "number",
  "High52Week": "number",
  "Low52Week": "number"
}
```

#### 2.9.1 `GET /api/v1/public/stocks`

- **Auth**: None
- **Input**:
  - Query: `page` (int, default 1), `limit` (int, default 10)
- **Output** (200, paginated): Array of Stock Objects

#### 2.9.2 `GET /api/v1/public/stocks/:stockSymbol`

- **Auth**: None
- **Input**:
  - Path: `stockSymbol` (string, e.g., "TCS", "RELIANCE")
- **Output** (200): Single Stock Object
- **Error**: 404 if not found

#### 2.9.3 `GET /api/v1/public/stocks/stock/random`

- **Auth**: None
- **Input**: None
- **Output** (200): Single random Stock Object

---

### 2.10 YouTube

**Data Source**: YouTube Data API (or cached JSON)

**Channel Object Schema**:
```json
{
  "id": "string",
  "title": "string",
  "description": "string",
  "customUrl": "string",
  "thumbnails": { "default": "string (URL)", "medium": "string (URL)", "high": "string (URL)" },
  "statistics": { "viewCount": "string", "subscriberCount": "string", "videoCount": "string" }
}
```

**Playlist Object Schema**:
```json
{
  "id": "string",
  "title": "string",
  "description": "string",
  "thumbnails": { "default": "string (URL)", "medium": "string (URL)", "high": "string (URL)" },
  "channelId": "string",
  "channelTitle": "string",
  "itemCount": "integer"
}
```

**Video Object Schema**:
```json
{
  "id": "string",
  "title": "string",
  "description": "string",
  "thumbnails": { "default": "string (URL)", "medium": "string (URL)", "high": "string (URL)" },
  "channelId": "string",
  "channelTitle": "string",
  "publishedAt": "ISO8601",
  "statistics": { "viewCount": "string", "likeCount": "string", "commentCount": "string" },
  "duration": "string (ISO8601)"
}
```

**Comment Object Schema**:
```json
{
  "id": "string",
  "authorDisplayName": "string",
  "authorProfileImageUrl": "string (URL)",
  "textDisplay": "string",
  "likeCount": "integer",
  "publishedAt": "ISO8601",
  "updatedAt": "ISO8601"
}
```

#### 2.10.1 `GET /api/v1/public/youtube/channel`

- **Auth**: None
- **Input**: None
- **Output** (200): Channel Object

#### 2.10.2 `GET /api/v1/public/youtube/playlists`

- **Auth**: None
- **Input**:
  - Query: `page` (int, default 1), `limit` (int, default 10)
- **Output** (200, paginated): Array of Playlist Objects

#### 2.10.3 `GET /api/v1/public/youtube/playlists/:playlistId`

- **Auth**: None
- **Input**:
  - Path: `playlistId` (string)
- **Output** (200): Single Playlist Object with `items` (array of Video Objects)

#### 2.10.4 `GET /api/v1/public/youtube/videos`

- **Auth**: None
- **Input**:
  - Query: `page` (int, default 1), `limit` (int, default 10), `sortBy` (enum: `mostViewed`, `mostLiked`, `latest`, `oldest`), `query` (string)
- **Output** (200, paginated): Array of Video Objects

#### 2.10.5 `GET /api/v1/public/youtube/videos/:videoId`

- **Auth**: None
- **Input**:
  - Path: `videoId` (string)
- **Output** (200): Single Video Object
- **Error**: 404 if not found

#### 2.10.6 `GET /api/v1/public/youtube/comments/:videoId`

- **Auth**: None
- **Input**:
  - Path: `videoId` (string)
- **Output** (200): Array of Comment Objects

#### 2.10.7 `GET /api/v1/public/youtube/related/:videoId`

- **Auth**: None
- **Input**:
  - Path: `videoId` (string)
- **Output** (200): Array of Video Objects (related videos)

---

## 3. User Authentication

> **Storage**: Persistent database (e.g., MongoDB, PostgreSQL)
> **Security**: JWT access + refresh tokens, bcrypt password hashing

### User Model Schema

```json
{
  "_id": "ObjectId",
  "avatar": { "url": "string (URL)", "localPath": "string" },
  "username": "string (unique, lowercase, 3-32 chars, required)",
  "email": "string (unique, lowercase, valid email, required)",
  "role": "enum: ADMIN | USER (default: USER)",
  "password": "string (bcrypt hashed, required)",
  "loginType": "enum: EMAIL_PASSWORD | GOOGLE | GITHUB",
  "isEmailVerified": "boolean (default: false)",
  "refreshToken": "string (nullable)",
  "forgotPasswordToken": "string (nullable)",
  "forgotPasswordExpiry": "ISO8601 (nullable)",
  "emailVerificationToken": "string (nullable)",
  "emailVerificationExpiry": "ISO8601 (nullable)",
  "createdAt": "ISO8601",
  "updatedAt": "ISO8601"
}
```

### 3.1 `POST /api/v1/users/register`

- **Auth**: None
- **Input** (body):
  ```json
  {
    "username": "string (3-32 chars, alphanumeric, required)",
    "email": "string (valid email, required)",
    "password": "string (min 6 chars, required)",
    "role": "string (ADMIN|USER, optional, default: USER)"
  }
  ```
- **Validation**:
  - Username must be unique
  - Email must be unique
  - Password must be at least 6 characters
- **Output** (201):
  ```json
  {
    "data": {
      "user": {
        "_id": "ObjectId",
        "username": "string",
        "email": "string",
        "avatar": { "url": "string", "localPath": "string" },
        "role": "string",
        "isEmailVerified": "boolean",
        "createdAt": "ISO8601",
        "updatedAt": "ISO8601"
      },
      "accessToken": "string (JWT)",
      "refreshToken": "string"
    },
    "message": "User registered successfully"
  }
  ```
- **Logic**:
  1. Validate input
  2. Check username/email uniqueness
  3. Hash password with bcrypt
  4. Create user in database
  5. Generate JWT access token (expires in 15 min)
  6. Generate refresh token (expires in 7 days)
  7. Store refresh token hash in database
  8. Return user (without password) + tokens

### 3.2 `POST /api/v1/users/login`

- **Auth**: None
- **Input** (body):
  ```json
  {
    "email": "string (required)",
    "password": "string (required)"
  }
  ```
- **Output** (200):
  ```json
  {
    "data": {
      "user": { ...User object without password... },
      "accessToken": "string (JWT)",
      "refreshToken": "string"
    },
    "message": "Login successful"
  }
  ```
- **Logic**:
  1. Find user by email
  2. Verify password with bcrypt
  3. Generate tokens
  4. Update refresh token in database
  5. Return user + tokens

### 3.3 `POST /api/v1/users/refresh-token`

- **Auth**: None
- **Input** (body):
  ```json
  {
    "refreshToken": "string (required)"
  }
  ```
- **Output** (200):
  ```json
  {
    "data": {
      "accessToken": "string (JWT)",
      "refreshToken": "string"
    }
  }
  ```
- **Logic**:
  1. Validate refresh token
  2. Find user with matching refresh token
  3. Generate new access + refresh tokens
  4. Update refresh token in database
  5. Return new tokens

### 3.4 `GET /api/v1/users/verify-email/:verificationToken`

- **Auth**: None
- **Input**:
  - Path: `verificationToken` (string)
- **Output** (200):
  ```json
  {
    "data": { "isEmailVerified": true },
    "message": "Email verified successfully"
  }
  ```
- **Logic**:
  1. Hash token with SHA256
  2. Find user with matching `emailVerificationToken` and non-expired `emailVerificationExpiry`
  3. Set `isEmailVerified = true`
  4. Clear `emailVerificationToken` and `emailVerificationExpiry`
  5. Save user

### 3.5 `POST /api/v1/users/forgot-password`

- **Auth**: None
- **Input** (body):
  ```json
  {
    "email": "string (required)"
  }
  ```
- **Output** (200):
  ```json
  {
    "message": "Password reset email sent"
  }
  ```
- **Logic**:
  1. Find user by email
  2. Generate temporary token (random string)
  3. Hash token with SHA256
  4. Store hash + expiry (1 hour) in database
  5. Send unhashed token via email (not implemented, just log or mock)

### 3.6 `POST /api/v1/users/reset-password/:resetToken`

- **Auth**: None
- **Input**:
  - Path: `resetToken` (string)
  - Body:
    ```json
    {
      "newPassword": "string (min 6 chars, required)"
    }
    ```
- **Output** (200):
  ```json
  {
    "message": "Password reset successful"
  }
  ```
- **Logic**:
  1. Hash token with SHA256
  2. Find user with matching `forgotPasswordToken` and valid `forgotPasswordExpiry`
  3. Hash new password with bcrypt
  4. Update password
  5. Clear `forgotPasswordToken` and `forgotPasswordExpiry`
  6. Save user

### 3.7 `POST /api/v1/users/logout`

- **Auth**: Bearer JWT
- **Input**: None
- **Output** (200):
  ```json
  {
    "message": "Logged out successfully"
  }
  ```
- **Logic**:
  1. Get user from JWT
  2. Clear `refreshToken` field in database

### 3.8 `PATCH /api/v1/users/avatar`

- **Auth**: Bearer JWT
- **Input**:
  - `multipart/form-data`: `avatar` (image file, required, max 2MB, image/jpeg|png|webp)
- **Output** (200):
  ```json
  {
    "data": {
      "user": { ...updated user with new avatar... }
    }
  }
  ```
- **Logic**:
  1. Validate file (type, size)
  2. Save file to disk or cloud storage
  3. Update user's `avatar.url` and `avatar.localPath`
  4. Delete old avatar file (if exists)
  5. Return updated user

### 3.9 `GET /api/v1/users/current-user`

- **Auth**: Bearer JWT
- **Input**: None
- **Output** (200):
  ```json
  {
    "data": {
      "_id": "ObjectId",
      "username": "string",
      "email": "string",
      "avatar": { "url": "string", "localPath": "string" },
      "role": "string",
      "isEmailVerified": "boolean",
      "createdAt": "ISO8601",
      "updatedAt": "ISO8601"
    }
  }
  ```
- **Logic**:
  1. Get user ID from JWT
  2. Fetch user from database
  3. Return user (without password, tokens)

### 3.10 `POST /api/v1/users/change-password`

- **Auth**: Bearer JWT
- **Input** (body):
  ```json
  {
    "oldPassword": "string (required)",
    "newPassword": "string (min 6 chars, required)"
  }
  ```
- **Output** (200):
  ```json
  {
    "message": "Password changed successfully"
  }
  ```
- **Logic**:
  1. Get user from JWT
  2. Verify old password with bcrypt
  3. Hash new password
  4. Update password in database
  5. Optionally invalidate all refresh tokens

### 3.11 `POST /api/v1/users/resend-email-verification`

- **Auth**: Bearer JWT
- **Input**: None
- **Output** (200):
  ```json
  {
    "message": "Verification email resent"
  }
  ```
- **Logic**:
  1. Get user from JWT
  2. If already verified, return error
  3. Generate new verification token
  4. Store hash + expiry (24 hours)
  5. Send email (mock/log)

### 3.12 `POST /api/v1/users/assign-role/:userId`

- **Auth**: Bearer JWT (ADMIN only)
- **Input**:
  - Path: `userId` (ObjectId string)
  - Body:
    ```json
    {
      "role": "string (ADMIN|USER, required)"
    }
    ```
- **Output** (200):
  ```json
  {
    "data": {
      "user": { ...updated user... }
    },
    "message": "Role updated"
  }
  ```
- **Logic**:
  1. Verify current user is ADMIN
  2. Find target user by ID
  3. Update role
  4. Return updated user

### 3.13 `GET /api/v1/users/google`

- **Auth**: None
- **Purpose**: OAuth 2.0 redirect to Google
- **Input**: None
- **Output**: HTTP 302 redirect to Google OAuth consent screen
- **Logic**:
  1. Generate state parameter (CSRF protection)
  2. Build Google OAuth URL with client_id, redirect_uri, scope, state
  3. Redirect user

### 3.14 `GET /api/v1/users/github`

- **Auth**: None
- **Purpose**: OAuth 2.0 redirect to GitHub
- **Input**: None
- **Output**: HTTP 302 redirect to GitHub OAuth consent screen
- **Logic**: Same as Google OAuth

### 3.15 `GET /api/v1/users/google/callback`

- **Auth**: None
- **Purpose**: OAuth 2.0 callback from Google
- **Input**:
  - Query: `code` (string, OAuth authorization code), `state` (string)
- **Output**: HTTP 302 redirect to frontend with tokens in query/hash
- **Logic**:
  1. Validate state parameter
  2. Exchange code for access token
  3. Fetch user info from Google
  4. Find or create user in database
  5. Generate JWT tokens
  6. Redirect to frontend with tokens

### 3.16 `GET /api/v1/users/github/callback`

- **Auth**: None
- **Purpose**: OAuth 2.0 callback from GitHub
- **Input**:
  - Query: `code` (string), `state` (string)
- **Output**: HTTP 302 redirect to frontend with tokens
- **Logic**: Same as Google callback

---

## 4. Todo App

> **Storage**: Database (e.g., MongoDB)
> **Auth**: Required for all endpoints

### Todo Model Schema

```json
{
  "_id": "ObjectId",
  "title": "string (required, 1-200 chars)",
  "description": "string (default: \"\")",
  "isComplete": "boolean (default: false)",
  "owner": "ObjectId (reference to User)",
  "createdAt": "ISO8601",
  "updatedAt": "ISO8601"
}
```

### 4.1 `GET /api/v1/todos`

- **Auth**: Bearer JWT
- **Input**:
  - Query: `page` (int, default 1), `limit` (int, default 10), `complete` (boolean, filter), `query` (string, search in title)
- **Output** (200, paginated):
  ```json
  {
    "data": [
      {
        "_id": "ObjectId",
        "title": "string",
        "description": "string",
        "isComplete": "boolean",
        "createdAt": "ISO8601",
        "updatedAt": "ISO8601"
      }
    ],
    "pagination": { ... }
  }
  ```
- **Logic**:
  1. Get user ID from JWT
  2. Query todos filtered by owner
  3. Apply optional filters (complete, query)
  4. Return paginated results

### 4.2 `POST /api/v1/todos`

- **Auth**: Bearer JWT
- **Input** (body):
  ```json
  {
    "title": "string (required, 1-200 chars)",
    "description": "string (optional, default: \"\")"
  }
  ```
- **Output** (201):
  ```json
  {
    "data": {
      "_id": "ObjectId",
      "title": "string",
      "description": "string",
      "isComplete": false,
      "createdAt": "ISO8601",
      "updatedAt": "ISO8601"
    }
  }
  ```
- **Logic**:
  1. Validate input
  2. Get user ID from JWT
  3. Create todo with owner reference
  4. Return created todo

### 4.3 `GET /api/v1/todos/:todoId`

- **Auth**: Bearer JWT
- **Input**:
  - Path: `todoId` (ObjectId string)
- **Output** (200):
  ```json
  {
    "data": { ...Todo object... }
  }
  ```
- **Logic**:
  1. Get user ID from JWT
  2. Find todo by ID where owner matches
  3. Return 404 if not found or not owned by user

### 4.4 `PATCH /api/v1/todos/:todoId`

- **Auth**: Bearer JWT
- **Input**:
  - Path: `todoId` (ObjectId string)
  - Body:
    ```json
    {
      "title": "string (optional, 1-200 chars)",
      "description": "string (optional)"
    }
    ```
- **Output** (200):
  ```json
  {
    "data": { ...updated Todo object... }
  }
  ```
- **Logic**:
  1. Get user ID from JWT
  2. Find todo by ID where owner matches
  3. Update allowed fields
  4. Return updated todo

### 4.5 `DELETE /api/v1/todos/:todoId`

- **Auth**: Bearer JWT
- **Input**:
  - Path: `todoId` (ObjectId string)
- **Output** (200):
  ```json
  {
    "message": "Todo deleted successfully"
  }
  ```
- **Logic**:
  1. Get user ID from JWT
  2. Find and delete todo where owner matches
  3. Return 404 if not found

### 4.6 `PATCH /api/v1/todos/toggle/status/:todoId`

- **Auth**: Bearer JWT
- **Input**:
  - Path: `todoId` (ObjectId string)
- **Output** (200):
  ```json
  {
    "data": { ...Todo with toggled isComplete... }
  }
  ```
- **Logic**:
  1. Get user ID from JWT
  2. Find todo by ID where owner matches
  3. Toggle `isComplete` (true → false, false → true)
  4. Return updated todo

---

## 5. E-commerce

> **Storage**: Database + file system for images
> **Auth**: Required for all endpoints
> **Admin**: Required for create/update/delete on products, categories, coupons, order status

### 5.1 Categories

#### Category Model Schema

```json
{
  "_id": "ObjectId",
  "name": "string (required, 1-100 chars)",
  "owner": "ObjectId (reference to User, ADMIN only)",
  "createdAt": "ISO8601",
  "updatedAt": "ISO8601"
}
```

#### 5.1.1 `GET /api/v1/ecommerce/categories`

- **Auth**: Bearer JWT
- **Input**:
  - Query: `page` (int, default 1), `limit` (int, default 10)
- **Output** (200, paginated): Array of Category Objects

#### 5.1.2 `POST /api/v1/ecommerce/categories`

- **Auth**: Bearer JWT (ADMIN only)
- **Input** (body):
  ```json
  {
    "name": "string (required, 1-100 chars)"
  }
  ```
- **Output** (201): Created Category Object

#### 5.1.3 `GET /api/v1/ecommerce/categories/:categoryId`

- **Auth**: Bearer JWT
- **Input**:
  - Path: `categoryId` (ObjectId string)
- **Output** (200): Single Category Object

#### 5.1.4 `PATCH /api/v1/ecommerce/categories/:categoryId`

- **Auth**: Bearer JWT (ADMIN only)
- **Input**:
  - Path: `categoryId` (ObjectId string)
  - Body:
    ```json
    {
      "name": "string (optional, 1-100 chars)"
    }
    ```
- **Output** (200): Updated Category Object

#### 5.1.5 `DELETE /api/v1/ecommerce/categories/:categoryId`

- **Auth**: Bearer JWT (ADMIN only)
- **Input**:
  - Path: `categoryId` (ObjectId string)
- **Output** (200):
  ```json
  {
    "message": "Category deleted"
  }
  ```
- **Side Effects**: Cascade delete all products in this category

---

### 5.2 Addresses

#### Address Model Schema

```json
{
  "_id": "ObjectId",
  "addressLine1": "string (required, 1-200 chars)",
  "addressLine2": "string (optional)",
  "city": "string (required, 1-100 chars)",
  "state": "string (required, 1-100 chars)",
  "country": "string (required, 1-100 chars)",
  "pincode": "string (required, 1-20 chars)",
  "owner": "ObjectId (reference to User)",
  "createdAt": "ISO8601",
  "updatedAt": "ISO8601"
}
```

#### 5.2.1 `GET /api/v1/ecommerce/addresses`

- **Auth**: Bearer JWT
- **Input**:
  - Query: `page` (int, default 1), `limit` (int, default 10)
- **Output** (200, paginated): Array of Address Objects (filtered by owner)

#### 5.2.2 `POST /api/v1/ecommerce/addresses`

- **Auth**: Bearer JWT
- **Input** (body):
  ```json
  {
    "addressLine1": "string (required)",
    "addressLine2": "string (optional)",
    "city": "string (required)",
    "state": "string (required)",
    "country": "string (required)",
    "pincode": "string (required)"
  }
  ```
- **Output** (201): Created Address Object

#### 5.2.3 `GET /api/v1/ecommerce/addresses/:addressId`

- **Auth**: Bearer JWT
- **Input**:
  - Path: `addressId` (ObjectId string)
- **Output** (200): Single Address Object (must be owned by user)

#### 5.2.4 `PATCH /api/v1/ecommerce/addresses/:addressId`

- **Auth**: Bearer JWT
- **Input**:
  - Path: `addressId` (ObjectId string)
  - Body: Same fields as create, all optional
- **Output** (200): Updated Address Object

#### 5.2.5 `DELETE /api/v1/ecommerce/addresses/:addressId`

- **Auth**: Bearer JWT
- **Input**:
  - Path: `addressId` (ObjectId string)
- **Output** (200):
  ```json
  {
    "message": "Address deleted"
  }
  ```

---

### 5.3 Products

#### Product Model Schema

```json
{
  "_id": "ObjectId",
  "name": "string (required, 1-200 chars)",
  "description": "string (required)",
  "price": "number (default: 0, min: 0)",
  "stock": "integer (default: 0, min: 0)",
  "category": "ObjectId (reference to Category, required)",
  "mainImage": {
    "url": "string (URL)",
    "localPath": "string"
  },
  "subImages": [
    { "url": "string (URL)", "localPath": "string" }
  ],
  "owner": "ObjectId (reference to User, ADMIN only)",
  "createdAt": "ISO8601",
  "updatedAt": "ISO8601"
}
```

#### 5.3.1 `GET /api/v1/ecommerce/products`

- **Auth**: Bearer JWT
- **Input**:
  - Query: `page` (int, default 1), `limit` (int, default 10)
- **Output** (200, paginated): Array of Product Objects with `category` populated

#### 5.3.2 `POST /api/v1/ecommerce/products`

- **Auth**: Bearer JWT (ADMIN only)
- **Input**: `multipart/form-data`
  - `name` (string, required)
  - `description` (string, required)
  - `price` (number, optional)
  - `stock` (number, optional)
  - `category` (ObjectId string, required)
  - `mainImage` (file, required, image/jpeg|png|webp, max 2MB)
  - `subImages` (files, optional, max 4 images)
- **Output** (201): Created Product Object with populated category

#### 5.3.3 `GET /api/v1/ecommerce/products/:productId`

- **Auth**: Bearer JWT
- **Input**:
  - Path: `productId` (ObjectId string)
- **Output** (200): Single Product Object with category populated

#### 5.3.4 `PATCH /api/v1/ecommerce/products/:productId`

- **Auth**: Bearer JWT (ADMIN only)
- **Input**: `multipart/form-data` — all fields optional
- **Output** (200): Updated Product Object

#### 5.3.5 `DELETE /api/v1/ecommerce/products/:productId`

- **Auth**: Bearer JWT (ADMIN only)
- **Input**:
  - Path: `productId` (ObjectId string)
- **Output** (200):
  ```json
  {
    "message": "Product deleted"
  }
  ```
- **Side Effects**: Delete mainImage and subImages from file system

#### 5.3.6 `GET /api/v1/ecommerce/products/category/:categoryId`

- **Auth**: Bearer JWT
- **Input**:
  - Path: `categoryId` (ObjectId string)
  - Query: `page` (int, default 1), `limit` (int, default 10)
- **Output** (200, paginated): Array of Product Objects in given category

#### 5.3.7 `PATCH /api/v1/ecommerce/products/remove/subimage/:productId/:subImageId`

- **Auth**: Bearer JWT (ADMIN only)
- **Input**:
  - Path: `productId` (ObjectId string), `subImageId` (ObjectId string)
- **Output** (200): Updated Product Object with sub-image removed
- **Side Effects**: Delete sub-image file from file system

---

### 5.4 E-commerce Profile

#### EcomProfile Model Schema

```json
{
  "_id": "ObjectId",
  "firstName": "string (default: \"John\")",
  "lastName": "string (default: \"Doe\")",
  "countryCode": "string (e.g., \"+1\")",
  "phoneNumber": "string",
  "owner": "ObjectId (reference to User, unique)",
  "createdAt": "ISO8601",
  "updatedAt": "ISO8601"
}
```

#### 5.4.1 `GET /api/v1/ecommerce/profile`

- **Auth**: Bearer JWT
- **Input**: None
- **Output** (200): User's EcomProfile Object

#### 5.4.2 `PATCH /api/v1/ecommerce/profile`

- **Auth**: Bearer JWT
- **Input** (body):
  ```json
  {
    "firstName": "string (optional)",
    "lastName": "string (optional)",
    "countryCode": "string (optional)",
    "phoneNumber": "string (optional)"
  }
  ```
- **Output** (200): Updated EcomProfile Object

#### 5.4.3 `GET /api/v1/ecommerce/profile/my-orders`

- **Auth**: Bearer JWT
- **Input**:
  - Query: `page` (int, default 1), `limit` (int, default 10)
- **Output** (200, paginated): Array of Order Objects (filtered by customer)

---

### 5.5 Cart

#### Cart Model Schema

```json
{
  "_id": "ObjectId",
  "owner": "ObjectId (reference to User, unique)",
  "items": [
    {
      "productId": "ObjectId (reference to Product)",
      "quantity": "integer (min: 1)"
    }
  ],
  "coupon": "ObjectId (reference to Coupon, nullable)",
  "createdAt": "ISO8601",
  "updatedAt": "ISO8601"
}
```

#### 5.5.1 `GET /api/v1/ecommerce/cart`

- **Auth**: Bearer JWT
- **Input**: None
- **Output** (200):
  ```json
  {
    "data": {
      "_id": "ObjectId",
      "owner": "ObjectId",
      "items": [
        {
          "productId": { ...Product object... },
          "quantity": "integer"
        }
      ],
      "coupon": { ...Coupon object or null... },
      "cartTotal": "number",
      "discountedTotal": "number",
      "createdAt": "ISO8601",
      "updatedAt": "ISO8601"
    }
  }
  ```
- **Logic**:
  1. Get or create cart for user
  2. Populate items with product details
  3. Calculate `cartTotal` (sum of price × quantity)
  4. Calculate `discountedTotal` if coupon applied

#### 5.5.2 `DELETE /api/v1/ecommerce/cart/clear`

- **Auth**: Bearer JWT
- **Input**: None
- **Output** (200):
  ```json
  {
    "message": "Cart cleared",
    "data": {
      "items": [],
      "cartTotal": 0
    }
  }
  ```
- **Logic**:
  1. Remove all items from cart
  2. Remove coupon if applied
  3. Reset totals

#### 5.5.3 `POST /api/v1/ecommerce/cart/item/:productId`

- **Auth**: Bearer JWT
- **Input**:
  - Path: `productId` (ObjectId string)
  - Body (optional):
    ```json
    {
      "quantity": "integer (default: 1, min: 1)"
    }
    ```
- **Output** (200): Updated Cart Object with new totals
- **Logic**:
  1. Get or create cart
  2. If item exists, increment quantity
  3. If item doesn't exist, add new item
  4. Recalculate totals
  5. Return updated cart

#### 5.5.4 `DELETE /api/v1/ecommerce/cart/item/:productId`

- **Auth**: Bearer JWT
- **Input**:
  - Path: `productId` (ObjectId string)
- **Output** (200): Updated Cart Object
- **Logic**:
  1. Remove item from cart
  2. Recalculate totals
  3. Return updated cart

---

### 5.6 Orders

#### EcomOrder Model Schema

```json
{
  "_id": "ObjectId",
  "orderPrice": "number",
  "discountedOrderPrice": "number",
  "coupon": "ObjectId (reference to Coupon, nullable)",
  "customer": "ObjectId (reference to User)",
  "items": [
    {
      "productId": "ObjectId",
      "quantity": "integer",
      "price": "number"
    }
  ],
  "address": {
    "addressLine1": "string",
    "addressLine2": "string",
    "city": "string",
    "state": "string",
    "country": "string",
    "pincode": "string"
  },
  "status": "enum: PENDING | CANCELLED | DELIVERED (default: PENDING)",
  "paymentProvider": "enum: UNKNOWN | RAZORPAY | PAYPAL",
  "paymentId": "string (nullable)",
  "isPaymentDone": "boolean (default: false)",
  "createdAt": "ISO8601",
  "updatedAt": "ISO8601"
}
```

#### 5.6.1 `POST /api/v1/ecommerce/orders/provider/razorpay`

- **Auth**: Bearer JWT
- **Input** (body):
  ```json
  {
    "addressId": "ObjectId (required)"
  }
  ```
- **Output** (201):
  ```json
  {
    "data": {
      "order": { ...EcomOrder object... },
      "razorpayOrder": {
        "id": "string",
        "amount": "number",
        "currency": "string"
      }
    }
  }
  ```
- **Logic**:
  1. Get user's cart with items
  2. Validate cart (not empty, sufficient stock)
  3. Get address by ID (must be owned by user)
  4. Create EcomOrder from cart
  5. Create Razorpay order via API (amount = order total)
  6. Clear user's cart
  7. Return order + Razorpay order

#### 5.6.2 `POST /api/v1/ecommerce/orders/provider/paypal`

- **Auth**: Bearer JWT
- **Input** (body):
  ```json
  {
    "addressId": "ObjectId (required)"
  }
  ```
- **Output** (201):
  ```json
  {
    "data": {
      "order": { ...EcomOrder object... },
      "paypalOrder": {
        "id": "string",
        "status": "string",
        "links": [ ... ]
      }
    }
  }
  ```
- **Logic**: Similar to Razorpay, but with PayPal API

#### 5.6.3 `POST /api/v1/ecommerce/orders/provider/razorpay/verify-payment`

- **Auth**: Bearer JWT
- **Input** (body):
  ```json
  {
    "razorpay_order_id": "string (required)",
    "razorpay_payment_id": "string (required)",
    "razorpay_signature": "string (required)"
  }
  ```
- **Output** (200):
  ```json
  {
    "data": {
      "order": { ...updated EcomOrder with isPaymentDone: true... }
    }
  }
  ```
- **Logic**:
  1. Verify Razorpay signature using HMAC-SHA256
  2. Find order by razorpay_order_id
  3. Update `paymentId`, `isPaymentDone = true`
  4. Return updated order

#### 5.6.4 `POST /api/v1/ecommerce/orders/provider/paypal/verify-payment`

- **Auth**: Bearer JWT
- **Input** (body):
  ```json
  {
    "orderId": "string (PayPal order ID, required)"
  }
  ```
- **Output** (200): Updated EcomOrder Object
- **Logic**: Verify with PayPal API, update order

#### 5.6.5 `GET /api/v1/ecommerce/orders/:orderId`

- **Auth**: Bearer JWT
- **Input**:
  - Path: `orderId` (ObjectId string)
- **Output** (200): Single Order Object with items and address populated
- **Logic**: Order must belong to current user (or ADMIN)

#### 5.6.6 `GET /api/v1/ecommerce/orders/list/admin`

- **Auth**: Bearer JWT (ADMIN only)
- **Input**:
  - Query: `page` (int, default 1), `limit` (int, default 10), `status` (enum, optional filter)
- **Output** (200, paginated): Array of all Order Objects

#### 5.6.7 `PATCH /api/v1/ecommerce/orders/status/:orderId`

- **Auth**: Bearer JWT (ADMIN only)
- **Input**:
  - Path: `orderId` (ObjectId string)
  - Body:
    ```json
    {
      "status": "enum: PENDING | CANCELLED | DELIVERED (required)"
    }
    ```
- **Output** (200): Updated Order Object

---

### 5.7 Coupons

#### Coupon Model Schema

```json
{
  "_id": "ObjectId",
  "name": "string (required, 1-100 chars)",
  "couponCode": "string (unique, uppercase, required, 3-20 chars)",
  "type": "enum: FLAT (default)",
  "discountValue": "number (required, min: 0)",
  "isActive": "boolean (default: true)",
  "minimumCartValue": "number (default: 0)",
  "startDate": "ISO8601 (nullable)",
  "expiryDate": "ISO8601 (nullable)",
  "owner": "ObjectId (reference to User, ADMIN only)",
  "createdAt": "ISO8601",
  "updatedAt": "ISO8601"
}
```

#### 5.7.1 `POST /api/v1/ecommerce/coupons/c/apply`

- **Auth**: Bearer JWT
- **Input** (body):
  ```json
  {
    "couponCode": "string (required, uppercase)"
  }
  ```
- **Output** (200):
  ```json
  {
    "data": {
      "cart": { ...Cart with coupon applied... },
      "discountedTotal": "number"
    },
    "message": "Coupon applied successfully"
  }
  ```
- **Logic**:
  1. Find coupon by code (case-insensitive)
  2. Validate: isActive, not expired, minimumCartValue met
  3. Apply coupon to cart
  4. Calculate discounted total
  5. Return updated cart

#### 5.7.2 `POST /api/v1/ecommerce/coupons/c/remove`

- **Auth**: Bearer JWT
- **Input** (body):
  ```json
  {
    "couponCode": "string (required)"
  }
  ```
- **Output** (200):
  ```json
  {
    "data": {
      "cart": { ...Cart with coupon removed... }
    },
    "message": "Coupon removed successfully"
  }
  ```
- **Logic**:
  1. Remove coupon reference from cart
  2. Reset discountedTotal to cartTotal
  3. Return updated cart

#### 5.7.3 `GET /api/v1/ecommerce/coupons/customer/available`

- **Auth**: Bearer JWT
- **Input**:
  - Query: `page` (int, default 1), `limit` (int, default 10)
- **Output** (200, paginated): Array of active, non-expired Coupon Objects

#### 5.7.4 `GET /api/v1/ecommerce/coupons`

- **Auth**: Bearer JWT (ADMIN only)
- **Input**:
  - Query: `page` (int, default 1), `limit` (int, default 10)
- **Output** (200, paginated): Array of all Coupon Objects

#### 5.7.5 `POST /api/v1/ecommerce/coupons`

- **Auth**: Bearer JWT (ADMIN only)
- **Input** (body):
  ```json
  {
    "name": "string (required)",
    "couponCode": "string (required, will be uppercased)",
    "type": "enum: FLAT (optional)",
    "discountValue": "number (required)",
    "minimumCartValue": "number (optional, default: 0)",
    "startDate": "ISO8601 (optional)",
    "expiryDate": "ISO8601 (optional)"
  }
  ```
- **Output** (201): Created Coupon Object

#### 5.7.6 `GET /api/v1/ecommerce/coupons/:couponId`

- **Auth**: Bearer JWT (ADMIN only)
- **Input**:
  - Path: `couponId` (ObjectId string)
- **Output** (200): Single Coupon Object

#### 5.7.7 `PATCH /api/v1/ecommerce/coupons/:couponId`

- **Auth**: Bearer JWT (ADMIN only)
- **Input**:
  - Path: `couponId` (ObjectId string)
  - Body: Same fields as create, all optional
- **Output** (200): Updated Coupon Object

#### 5.7.8 `DELETE /api/v1/ecommerce/coupons/:couponId`

- **Auth**: Bearer JWT (ADMIN only)
- **Input**:
  - Path: `couponId` (ObjectId string)
- **Output** (200):
  ```json
  {
    "message": "Coupon deleted"
  }
  ```

#### 5.7.9 `PATCH /api/v1/ecommerce/coupons/status/:couponId`

- **Auth**: Bearer JWT (ADMIN only)
- **Input**:
  - Path: `couponId` (ObjectId string)
  - Body:
    ```json
    {
      "isActive": "boolean (required)"
    }
    ```
- **Output** (200): Updated Coupon Object with toggled status

---

## 6. Social Media

> **Storage**: Database + file system for images
> **Auth**: Required for all endpoints

### 6.1 Profile

#### SocialProfile Model Schema

```json
{
  "_id": "ObjectId",
  "coverImage": { "url": "string (URL)", "localPath": "string" },
  "firstName": "string (default: \"\")",
  "lastName": "string (default: \"\")",
  "bio": "string (default: \"\", max 500 chars)",
  "dob": "ISO8601 (nullable)",
  "location": "string (default: \"\")",
  "countryCode": "string (nullable)",
  "phoneNumber": "string (nullable)",
  "owner": "ObjectId (reference to User, unique)",
  "createdAt": "ISO8601",
  "updatedAt": "ISO8601"
}
```

#### 6.1.1 `GET /api/v1/social-media/profile/u/:username`

- **Auth**: Bearer JWT
- **Input**:
  - Path: `username` (string)
- **Output** (200):
  ```json
  {
    "data": {
      "_id": "ObjectId",
      "coverImage": { ... },
      "firstName": "string",
      "lastName": "string",
      "bio": "string",
      "dob": "ISO8601",
      "location": "string",
      "countryCode": "string",
      "phoneNumber": "string",
      "owner": { "_id": "ObjectId", "username": "string", "avatar": { ... } },
      "followersCount": "integer",
      "followingCount": "integer",
      "isFollowing": "boolean (relative to current user)",
      "createdAt": "ISO8601",
      "updatedAt": "ISO8601"
    }
  }
  ```

#### 6.1.2 `GET /api/v1/social-media/profile`

- **Auth**: Bearer JWT
- **Input**: None
- **Output** (200): Current user's SocialProfile Object

#### 6.1.3 `PATCH /api/v1/social-media/profile`

- **Auth**: Bearer JWT
- **Input** (body):
  ```json
  {
    "firstName": "string (optional)",
    "lastName": "string (optional)",
    "bio": "string (optional, max 500 chars)",
    "dob": "ISO8601 (optional)",
    "location": "string (optional)",
    "countryCode": "string (optional)",
    "phoneNumber": "string (optional)"
  }
  ```
- **Output** (200): Updated SocialProfile Object

#### 6.1.4 `PATCH /api/v1/social-media/profile/cover-image`

- **Auth**: Bearer JWT
- **Input**:
  - `multipart/form-data`: `coverImage` (file, image/jpeg|png|webp, max 2MB)
- **Output** (200): Updated SocialProfile Object with new cover image

---

### 6.2 Follow

#### SocialFollow Model Schema

```json
{
  "_id": "ObjectId",
  "followerId": "ObjectId (reference to User)",
  "followeeId": "ObjectId (reference to User)",
  "createdAt": "ISO8601",
  "updatedAt": "ISO8601"
}
```

#### 6.2.1 `POST /api/v1/social-media/follow/:toBeFollowedUserId`

- **Auth**: Bearer JWT
- **Input**:
  - Path: `toBeFollowedUserId` (ObjectId string)
- **Output** (200):
  ```json
  {
    "data": { "following": "boolean" },
    "message": "Followed successfully" | "Unfollowed successfully"
  }
  ```
- **Logic**:
  1. Check if follow relationship exists
  2. If exists, delete (unfollow)
  3. If not exists, create (follow)
  4. Return current state

#### 6.2.2 `GET /api/v1/social-media/follow/list/followers/:username`

- **Auth**: Bearer JWT
- **Input**:
  - Path: `username` (string)
  - Query: `page` (int, default 1), `limit` (int, default 10)
- **Output** (200, paginated):
  ```json
  {
    "data": [
      {
        "_id": "ObjectId",
        "username": "string",
        "avatar": { "url": "string", "localPath": "string" },
        "isFollowing": "boolean (relative to current user)"
      }
    ]
  }
  ```

#### 6.2.3 `GET /api/v1/social-media/follow/list/following/:username`

- **Auth**: Bearer JWT
- **Input**:
  - Path: `username` (string)
  - Query: `page` (int, default 1), `limit` (int, default 10)
- **Output** (200, paginated): Same structure as followers

---

### 6.3 Posts

#### SocialPost Model Schema

```json
{
  "_id": "ObjectId",
  "content": "string (required, 1-1000 chars)",
  "tags": ["string"],
  "images": [
    { "url": "string (URL)", "localPath": "string" }
  ],
  "author": "ObjectId (reference to User)",
  "createdAt": "ISO8601",
  "updatedAt": "ISO8601"
}
```

#### 6.3.1 `GET /api/v1/social-media/posts`

- **Auth**: Bearer JWT
- **Input**:
  - Query: `page` (int, default 1), `limit` (int, default 10)
- **Output** (200, paginated):
  ```json
  {
    "data": [
      {
        "_id": "ObjectId",
        "content": "string",
        "tags": ["string"],
        "images": [ ... ],
        "author": { "_id": "ObjectId", "username": "string", "avatar": { ... } },
        "likesCount": "integer",
        "commentsCount": "integer",
        "isLiked": "boolean (relative to current user)",
        "isBookmarked": "boolean (relative to current user)",
        "createdAt": "ISO8601",
        "updatedAt": "ISO8601"
      }
    ]
  }
  ```

#### 6.3.2 `POST /api/v1/social-media/posts`

- **Auth**: Bearer JWT
- **Input**: `multipart/form-data`
  - `content` (string, required, 1-1000 chars)
  - `tags` (string, JSON array or comma-separated)
  - `images` (files, max 6, image/jpeg|png|webp, max 2MB each)
- **Output** (201): Created SocialPost Object

#### 6.3.3 `GET /api/v1/social-media/posts/get/my`

- **Auth**: Bearer JWT
- **Input**:
  - Query: `page` (int, default 1), `limit` (int, default 10)
- **Output** (200, paginated): Current user's posts

#### 6.3.4 `GET /api/v1/social-media/posts/get/u/:username`

- **Auth**: Bearer JWT
- **Input**:
  - Path: `username` (string)
  - Query: `page` (int, default 1), `limit` (int, default 10)
- **Output** (200, paginated): Posts by specified user

#### 6.3.5 `GET /api/v1/social-media/posts/get/t/:tag`

- **Auth**: Bearer JWT
- **Input**:
  - Path: `tag` (string)
  - Query: `page` (int, default 1), `limit` (int, default 10)
- **Output** (200, paginated): Posts with matching tag

#### 6.3.6 `GET /api/v1/social-media/posts/:postId`

- **Auth**: Bearer JWT
- **Input**:
  - Path: `postId` (ObjectId string)
- **Output** (200): Single Post Object with author, likesCount, commentsCount, isLiked, isBookmarked

#### 6.3.7 `PATCH /api/v1/social-media/posts/:postId`

- **Auth**: Bearer JWT (post owner only)
- **Input**: `multipart/form-data` — `content`, `tags`, `images` (all optional)
- **Output** (200): Updated SocialPost Object

#### 6.3.8 `DELETE /api/v1/social-media/posts/:postId`

- **Auth**: Bearer JWT (post owner only)
- **Input**:
  - Path: `postId` (ObjectId string)
- **Output** (200):
  ```json
  {
    "message": "Post deleted"
  }
  ```
- **Side Effects**:
  - Delete all comments associated with this post
  - Delete all likes associated with this post
  - Delete all bookmarks associated with this post
  - Remove images from file system

#### 6.3.9 `PATCH /api/v1/social-media/posts/remove/image/:postId/:imageId`

- **Auth**: Bearer JWT (post owner only)
- **Input**:
  - Path: `postId` (ObjectId string), `imageId` (ObjectId string)
- **Output** (200): Updated SocialPost Object with image removed
- **Side Effects**: Delete image file from file system

---

### 6.4 Likes

#### SocialLike Model Schema

```json
{
  "_id": "ObjectId",
  "postId": "ObjectId (reference to SocialPost, nullable)",
  "commentId": "ObjectId (reference to SocialComment, nullable)",
  "likedBy": "ObjectId (reference to User)",
  "createdAt": "ISO8601",
  "updatedAt": "ISO8601"
}
```

#### 6.4.1 `POST /api/v1/social-media/like/post/:postId`

- **Auth**: Bearer JWT
- **Input**:
  - Path: `postId` (ObjectId string)
- **Output** (200):
  ```json
  {
    "data": { "isLiked": "boolean" },
    "message": "Post liked" | "Post unliked"
  }
  ```
- **Logic**: Toggle like — create if not exists, delete if exists

#### 6.4.2 `POST /api/v1/social-media/like/comment/:commentId`

- **Auth**: Bearer JWT
- **Input**:
  - Path: `commentId` (ObjectId string)
- **Output** (200):
  ```json
  {
    "data": { "isLiked": "boolean" },
    "message": "Comment liked" | "Comment unliked"
  }
  ```

---

### 6.5 Bookmarks

#### SocialBookmark Model Schema

```json
{
  "_id": "ObjectId",
  "postId": "ObjectId (reference to SocialPost)",
  "bookmarkedBy": "ObjectId (reference to User)",
  "createdAt": "ISO8601",
  "updatedAt": "ISO8601"
}
```

#### 6.5.1 `GET /api/v1/social-media/bookmarks`

- **Auth**: Bearer JWT
- **Input**:
  - Query: `page` (int, default 1), `limit` (int, default 10)
- **Output** (200, paginated):
  ```json
  {
    "data": [
      {
        "_id": "ObjectId",
        "postId": { ...full Post object with author, counts... },
        "createdAt": "ISO8601"
      }
    ]
  }
  ```

#### 6.5.2 `POST /api/v1/social-media/bookmarks/:postId`

- **Auth**: Bearer JWT
- **Input**:
  - Path: `postId` (ObjectId string)
- **Output** (200):
  ```json
  {
    "data": { "isBookmarked": "boolean" },
    "message": "Post bookmarked" | "Post unbookmarked"
  }
  ```
- **Logic**: Toggle bookmark

---

### 6.6 Comments

#### SocialComment Model Schema

```json
{
  "_id": "ObjectId",
  "content": "string (required, 1-500 chars)",
  "postId": "ObjectId (reference to SocialPost)",
  "author": "ObjectId (reference to User)",
  "createdAt": "ISO8601",
  "updatedAt": "ISO8601"
}
```

#### 6.6.1 `GET /api/v1/social-media/comments/post/:postId`

- **Auth**: Bearer JWT
- **Input**:
  - Path: `postId` (ObjectId string)
  - Query: `page` (int, default 1), `limit` (int, default 10)
- **Output** (200, paginated):
  ```json
  {
    "data": [
      {
        "_id": "ObjectId",
        "content": "string",
        "author": { "_id": "ObjectId", "username": "string", "avatar": { ... } },
        "likesCount": "integer",
        "isLiked": "boolean (relative to current user)",
        "createdAt": "ISO8601",
        "updatedAt": "ISO8601"
      }
    ]
  }
  ```

#### 6.6.2 `POST /api/v1/social-media/comments/post/:postId`

- **Auth**: Bearer JWT
- **Input**:
  - Path: `postId` (ObjectId string)
  - Body:
    ```json
    {
      "content": "string (required, 1-500 chars)"
    }
    ```
- **Output** (201): Created SocialComment Object

#### 6.6.3 `PATCH /api/v1/social-media/comments/:commentId`

- **Auth**: Bearer JWT (comment author only)
- **Input**:
  - Path: `commentId` (ObjectId string)
  - Body:
    ```json
    {
      "content": "string (required, 1-500 chars)"
    }
    ```
- **Output** (200): Updated SocialComment Object

#### 6.6.4 `DELETE /api/v1/social-media/comments/:commentId`

- **Auth**: Bearer JWT (comment author only)
- **Input**:
  - Path: `commentId` (ObjectId string)
- **Output** (200):
  ```json
  {
    "message": "Comment deleted"
  }
  ```
- **Side Effects**: Delete all likes on this comment

---

## 7. Chat App

> **Storage**: Database + file system for attachments
> **Real-time**: WebSocket for live messaging
> **Auth**: Required for all endpoints

### 7.1 Chats

#### Chat Model Schema

```json
{
  "_id": "ObjectId",
  "name": "string (nullable, required for group chats)",
  "isGroupChat": "boolean (default: false)",
  "lastMessage": "ObjectId (reference to ChatMessage, nullable)",
  "participants": ["ObjectId (reference to User)"],
  "admin": "ObjectId (reference to User, nullable, required for group chats)",
  "createdAt": "ISO8601",
  "updatedAt": "ISO8601"
}
```

#### 7.1.1 `GET /api/v1/chat-app/chats`

- **Auth**: Bearer JWT
- **Input**: None
- **Output** (200):
  ```json
  {
    "data": [
      {
        "_id": "ObjectId",
        "name": "string",
        "isGroupChat": "boolean",
        "participants": [
          { "_id": "ObjectId", "username": "string", "avatar": { ... }, "email": "string" }
        ],
        "admin": { "_id": "ObjectId", "username": "string" },
        "lastMessage": {
          "_id": "ObjectId",
          "content": "string",
          "sender": { "_id": "ObjectId", "username": "string" },
          "createdAt": "ISO8601"
        },
        "createdAt": "ISO8601",
        "updatedAt": "ISO8601"
      }
    ]
  }
  ```
- **Logic**: Return all chats where current user is a participant

#### 7.1.2 `GET /api/v1/chat-app/chats/users`

- **Auth**: Bearer JWT
- **Input**: None
- **Output** (200):
  ```json
  {
    "data": [
      {
        "_id": "ObjectId",
        "username": "string",
        "avatar": { "url": "string", "localPath": "string" },
        "email": "string"
      }
    ]
  }
  ```
- **Logic**: Return all users except current user (for creating new chats)

#### 7.1.3 `POST /api/v1/chat-app/chats/c/:receiverId`

- **Auth**: Bearer JWT
- **Input**:
  - Path: `receiverId` (ObjectId string)
- **Output** (200):
  ```json
  {
    "data": { ...Chat object (one-on-one)... }
  }
  ```
- **Logic**:
  1. Check if chat between current user and receiver already exists
  2. If exists, return it
  3. If not, create new one-on-one chat
  4. Add both users as participants

#### 7.1.4 `POST /api/v1/chat-app/chats/group`

- **Auth**: Bearer JWT
- **Input** (body):
  ```json
  {
    "name": "string (required, 1-100 chars)",
    "participants": ["ObjectId", "ObjectId"]
  }
  ```
  - Minimum 2 participants (excluding current user who is auto-added)
  - All participant IDs must be valid
- **Output** (201):
  ```json
  {
    "data": {
      "_id": "ObjectId",
      "name": "string",
      "isGroupChat": true,
      "participants": [ ...populated user objects... ],
      "admin": { "_id": "ObjectId", "username": "string" },
      "createdAt": "ISO8601",
      "updatedAt": "ISO8601"
    }
  }
  ```
- **Logic**:
  1. Validate participants (min 2, valid IDs)
  2. Create group chat with current user as admin
  3. Add all participants
  4. Return populated chat

#### 7.1.5 `GET /api/v1/chat-app/chats/group/:chatId`

- **Auth**: Bearer JWT (must be participant)
- **Input**:
  - Path: `chatId` (ObjectId string)
- **Output** (200): Group Chat Object with populated participants

#### 7.1.6 `PATCH /api/v1/chat-app/chats/group/:chatId`

- **Auth**: Bearer JWT (group admin only)
- **Input**:
  - Path: `chatId` (ObjectId string)
  - Body:
    ```json
    {
      "name": "string (required, 1-100 chars)"
    }
    ```
- **Output** (200): Updated Group Chat Object
- **WebSocket Event**: `updateGroupName` to all participants

#### 7.1.7 `DELETE /api/v1/chat-app/chats/group/:chatId`

- **Auth**: Bearer JWT (group admin only)
- **Input**:
  - Path: `chatId` (ObjectId string)
- **Output** (200):
  ```json
  {
    "message": "Group chat deleted"
  }
  ```
- **Side Effects**:
  - Delete all messages in this chat
  - Emit WebSocket event `leaveChat` to all participants

#### 7.1.8 `POST /api/v1/chat-app/chats/group/:chatId/:participantId`

- **Auth**: Bearer JWT (group admin only)
- **Input**:
  - Path: `chatId` (ObjectId string), `participantId` (ObjectId string)
- **Output** (200): Updated Group Chat Object
- **Logic**: Add participant to group
- **WebSocket Event**: `newChat` to added participant

#### 7.1.9 `DELETE /api/v1/chat-app/chats/group/:chatId/:participantId`

- **Auth**: Bearer JWT (group admin only)
- **Input**:
  - Path: `chatId` (ObjectId string), `participantId` (ObjectId string)
- **Output** (200): Updated Group Chat Object
- **Logic**: Remove participant from group
- **WebSocket Event**: `leaveChat` to removed participant

#### 7.1.10 `DELETE /api/v1/chat-app/chats/leave/group/:chatId`

- **Auth**: Bearer JWT
- **Input**:
  - Path: `chatId` (ObjectId string)
- **Output** (200):
  ```json
  {
    "message": "Left group successfully"
  }
  ```
- **Logic**:
  1. Remove current user from participants
  2. If current user is admin, assign new admin (first participant)
  3. Emit WebSocket event `leaveChat` to all participants

#### 7.1.11 `DELETE /api/v1/chat-app/chats/remove/:chatId`

- **Auth**: Bearer JWT
- **Input**:
  - Path: `chatId` (ObjectId string)
- **Output** (200):
  ```json
  {
    "message": "Chat deleted"
  }
  ```
- **Logic**:
  - Only for one-on-one chats
  - Delete chat and all messages

---

### 7.2 Messages

#### ChatMessage Model Schema

```json
{
  "_id": "ObjectId",
  "sender": "ObjectId (reference to User)",
  "content": "string (default: \"\")",
  "attachments": [
    { "url": "string (URL)", "localPath": "string" }
  ],
  "chat": "ObjectId (reference to Chat)",
  "createdAt": "ISO8601",
  "updatedAt": "ISO8601"
}
```

#### 7.2.1 `GET /api/v1/chat-app/messages/:chatId`

- **Auth**: Bearer JWT (must be chat participant)
- **Input**:
  - Path: `chatId` (ObjectId string)
- **Output** (200):
  ```json
  {
    "data": [
      {
        "_id": "ObjectId",
        "sender": {
          "_id": "ObjectId",
          "username": "string",
          "avatar": { "url": "string", "localPath": "string" },
          "email": "string"
        },
        "content": "string",
        "attachments": [ { "url": "string", "localPath": "string" } ],
        "chat": "ObjectId",
        "createdAt": "ISO8601",
        "updatedAt": "ISO8601"
      }
    ]
  }
  ```

#### 7.2.2 `POST /api/v1/chat-app/messages/:chatId`

- **Auth**: Bearer JWT (must be chat participant)
- **Input**: `multipart/form-data`
  - `content` (string, optional if attachments provided)
  - `attachments` (files, max 5, any type, max 10MB each)
- **Output** (201):
  ```json
  {
    "data": {
      "_id": "ObjectId",
      "sender": { ...populated user object... },
      "content": "string",
      "attachments": [ ... ],
      "chat": "ObjectId",
      "createdAt": "ISO8601",
      "updatedAt": "ISO8601"
    }
  }
  ```
- **Side Effects**:
  1. Update `lastMessage` on chat
  2. Emit WebSocket event `messageReceived` to all participants

#### 7.2.3 `DELETE /api/v1/chat-app/messages/:chatId/:messageId`

- **Auth**: Bearer JWT (message sender only)
- **Input**:
  - Path: `chatId` (ObjectId string), `messageId` (ObjectId string)
- **Output** (200):
  ```json
  {
    "message": "Message deleted"
  }
  ```
- **Side Effects**:
  - Delete message
  - Update `lastMessage` on chat if needed
  - Emit WebSocket event `messageDeleted` to all participants

---

## 8. Kitchen Sink

> **Purpose**: Utility APIs for testing HTTP concepts
> **Auth**: None required

### 8.1 HTTP Methods

#### 8.1.1 `GET /api/v1/kitchen-sink/http-methods/get`

- **Auth**: None
- **Input**: None
- **Output** (200):
  ```json
  {
    "data": {
      "method": "GET",
      "body": null
    },
    "message": "GET request successful"
  }
  ```

#### 8.1.2 `POST /api/v1/kitchen-sink/http-methods/post`

- **Auth**: None
- **Input**: Body (any JSON)
- **Output** (200):
  ```json
  {
    "data": {
      "method": "POST",
      "body": { ...echoed body... }
    },
    "message": "POST request successful"
  }
  ```

#### 8.1.3 `PUT /api/v1/kitchen-sink/http-methods/put`

- **Auth**: None
- **Input**: Body (any JSON)
- **Output** (200): Echo body with method = "PUT"

#### 8.1.4 `PATCH /api/v1/kitchen-sink/http-methods/patch`

- **Auth**: None
- **Input**: Body (any JSON)
- **Output** (200): Echo body with method = "PATCH"

#### 8.1.5 `DELETE /api/v1/kitchen-sink/http-methods/delete`

- **Auth**: None
- **Input**: None
- **Output** (200):
  ```json
  {
    "data": {
      "method": "DELETE",
      "body": null
    },
    "message": "DELETE request successful"
  }
  ```

---

### 8.2 Status Codes

#### 8.2.1 `GET /api/v1/kitchen-sink/status-codes`

- **Auth**: None
- **Input**: None
- **Output** (200):
  ```json
  {
    "data": {
      "statusCodes": [
        { "code": 100, "name": "Continue" },
        { "code": 200, "name": "OK" },
        ...
      ]
    }
  }
  ```

#### 8.2.2 `GET /api/v1/kitchen-sink/status-codes/:statusCode`

- **Auth**: None
- **Input**:
  - Path: `statusCode` (int, 100-599)
- **Output**: Response with requested status code
- **Error**: 400 if status code not in valid range

---

### 8.3 Request Inspection

#### 8.3.1 `GET /api/v1/kitchen-sink/request/headers`

- **Auth**: None
- **Input**: None
- **Output** (200):
  ```json
  {
    "data": {
      "headers": { ...all request headers... }
    }
  }
  ```

#### 8.3.2 `GET /api/v1/kitchen-sink/request/ip`

- **Auth**: None
- **Input**: None
- **Output** (200):
  ```json
  {
    "data": {
      "ip": "string (client IP address)"
    }
  }
  ```

#### 8.3.3 `GET /api/v1/kitchen-sink/request/user-agent`

- **Auth**: None
- **Input**: None
- **Output** (200):
  ```json
  {
    "data": {
      "userAgent": "string"
    }
  }
  ```

#### 8.3.4 `GET /api/v1/kitchen-sink/request/path-variable/:pathVariable`

- **Auth**: None
- **Input**:
  - Path: `pathVariable` (string)
- **Output** (200):
  ```json
  {
    "data": {
      "pathVariable": "string"
    }
  }
  ```

#### 8.3.5 `GET /api/v1/kitchen-sink/request/query-parameter`

- **Auth**: None
- **Input**:
  - Query: any key-value pairs
- **Output** (200):
  ```json
  {
    "data": {
      "query": { ...all query parameters... }
    }
  }
  ```

---

### 8.4 Response Inspection

#### 8.4.1 `GET /api/v1/kitchen-sink/response/cache/:timeToLive/:cacheResponseDirective`

- **Auth**: None
- **Input**:
  - Path: `timeToLive` (int, seconds), `cacheResponseDirective` (enum: `public`, `private`, `no-cache`, `no-store`)
- **Output** (200): Response with `Cache-Control` header set
- **Headers**: `Cache-Control: <directive>, max-age=<ttl>`

#### 8.4.2 `GET /api/v1/kitchen-sink/response/headers`

- **Auth**: None
- **Input**: None
- **Output** (200):
  ```json
  {
    "data": {
      "headers": { ...response headers... }
    }
  }
  ```

#### 8.4.3 `GET /api/v1/kitchen-sink/response/html`

- **Auth**: None
- **Input**: None
- **Output** (200):
  - Content-Type: `text/html`
  - Body: `<html><body><h1>Hello World</h1></body></html>`

#### 8.4.4 `GET /api/v1/kitchen-sink/response/xml`

- **Auth**: None
- **Input**: None
- **Output** (200):
  - Content-Type: `text/xml`
  - Body: `<?xml version="1.0"?><root><message>Hello</message></root>`

#### 8.4.5 `GET /api/v1/kitchen-sink/response/gzip`

- **Auth**: None
- **Input**: None
- **Output** (200):
  - Content-Encoding: `gzip`
  - Body: Gzip-compressed response

#### 8.4.6 `GET /api/v1/kitchen-sink/response/brotli`

- **Auth**: None
- **Input**: None
- **Output** (200):
  - Content-Encoding: `br`
  - Body: Brotli-compressed response

---

### 8.5 Cookies

#### 8.5.1 `GET /api/v1/kitchen-sink/cookies/get`

- **Auth**: None
- **Input**: None
- **Output** (200):
  ```json
  {
    "data": {
      "cookies": { ...all cookies... }
    }
  }
  ```

#### 8.5.2 `POST /api/v1/kitchen-sink/cookies/set`

- **Auth**: None
- **Input** (body):
  ```json
  {
    "name": "string (required)",
    "value": "string (required)",
    "maxAge": "number (optional, seconds)",
    "httpOnly": "boolean (optional, default: true)",
    "secure": "boolean (optional, default: false)",
    "sameSite": "enum: strict|lax|none (optional, default: lax)"
  }
  ```
- **Output** (200):
  ```json
  {
    "message": "Cookie set successfully"
  }
  ```
- **Side Effects**: Set-Cookie header in response

#### 8.5.3 `DELETE /api/v1/kitchen-sink/cookies/remove`

- **Auth**: None
- **Input** (body):
  ```json
  {
    "name": "string (required)"
  }
  ```
- **Output** (200):
  ```json
  {
    "message": "Cookie removed successfully"
  }
  ```
- **Side Effects**: Set-Cookie header with expired maxAge

---

### 8.6 Redirect

#### 8.6.1 `GET /api/v1/kitchen-sink/redirect/to`

- **Auth**: None
- **Input**:
  - Query: `url` (string, required), `statusCode` (int, optional, default: 302)
- **Output**: HTTP redirect (301, 302, 307, or 308)
- **Error**: 400 if url missing or invalid

---

### 8.7 Images

#### 8.7.1 `GET /api/v1/kitchen-sink/image/jpeg`

- **Auth**: None
- **Output**: JPEG image (Content-Type: `image/jpeg`)

#### 8.7.2 `GET /api/v1/kitchen-sink/image/jpg`

- **Auth**: None
- **Output**: JPG image (Content-Type: `image/jpeg`)

#### 8.7.3 `GET /api/v1/kitchen-sink/image/png`

- **Auth**: None
- **Output**: PNG image (Content-Type: `image/png`)

#### 8.7.4 `GET /api/v1/kitchen-sink/image/svg`

- **Auth**: None
- **Output**: SVG image (Content-Type: `image/svg+xml`)

#### 8.7.5 `GET /api/v1/kitchen-sink/image/webp`

- **Auth**: None
- **Output**: WebP image (Content-Type: `image/webp`)

---

## 9. Seeding & Admin

> **Purpose**: Populate database with test data

### 9.1 `GET /api/v1/seed/generated-credentials`

- **Auth**: None
- **Output** (200):
  ```json
  {
    "data": {
      "users": [
        {
          "username": "string",
          "email": "string",
          "password": "string (plaintext for testing)",
          "role": "string"
        }
      ]
    }
  }
  ```
- **Logic**: Return pre-generated test credentials

### 9.2 `POST /api/v1/seed/todos`

- **Auth**: Bearer JWT
- **Input**: None
- **Output** (200):
  ```json
  {
    "message": "Todos seeded successfully"
  }
  ```
- **Logic**: Create 10-20 sample todos for current user

### 9.3 `POST /api/v1/seed/ecommerce`

- **Auth**: Bearer JWT
- **Input**: None
- **Output** (200):
  ```json
  {
    "message": "E-commerce data seeded"
  }
  ```
- **Logic**: Create sample categories, products, addresses for current user

### 9.4 `POST /api/v1/seed/social-media`

- **Auth**: Bearer JWT
- **Input**: None
- **Output** (200):
  ```json
  {
    "message": "Social media data seeded"
  }
  ```
- **Logic**: Create sample social profile, posts for current user

### 9.5 `POST /api/v1/seed/chat-app`

- **Auth**: Bearer JWT
- **Input**: None
- **Output** (200):
  ```json
  {
    "message": "Chat app data seeded"
  }
  ```
- **Logic**: Create sample chats, messages for current user

### 9.6 `DELETE /api/v1/reset-db`

- **Auth**: Bearer JWT (ADMIN only)
- **Input**: None
- **Output** (200):
  ```json
  {
    "message": "Database reset successfully"
  }
  ```
- **Logic**:
  1. Drop all collections/tables
  2. Re-seed public data from JSON files (users, products, jokes, etc.)
  3. Create default admin user

---

## Appendix A: WebSocket Events (Chat App)

| Event Name | Direction | Payload | Description |
|------------|-----------|---------|-------------|
| `connect` | Client → Server | `{ authToken: "string" }` | Authenticate and establish connection |
| `disconnect` | Client → Server | None | Close connection |
| `sendMessage` | Client → Server | `{ chatId: "string", content: "string", attachments: [...] }` | Send a chat message |
| `messageReceived` | Server → Client | `{ ...ChatMessage object... }` | New message in chat |
| `messageDeleted` | Server → Client | `{ chatId: "string", messageId: "string" }` | Message was deleted |
| `updateGroupName` | Server → Client | `{ chatId: "string", newName: "string" }` | Group chat name changed |
| `leaveChat` | Server → Client | `{ chatId: "string", userId: "string" }` | User left/joined chat |
| `newChat` | Server → Client | `{ ...Chat object... }` | Added to new chat |
| `typing` | Client → Server | `{ chatId: "string", isTyping: "boolean" }` | User typing indicator |
| `userTyping` | Server → Client | `{ chatId: "string", userId: "string", isTyping: "boolean" }` | Broadcast typing status |

---

## Appendix B: JWT Token Structure

### Access Token (15 min expiry)

```json
{
  "sub": "ObjectId (user ID)",
  "username": "string",
  "email": "string",
  "role": "enum: ADMIN | USER",
  "iat": "number (issued at)",
  "exp": "number (expiration)"
}
```

### Refresh Token (7 days expiry)

Stored in database (hashed), sent to client as opaque string.

---

## Appendix C: File Upload Specifications

### Image Files

- **Accepted Types**: `image/jpeg`, `image/png`, `image/webp`
- **Max Size**: 2MB per file
- **Storage**: File system or cloud storage (e.g., S3)
- **Naming**: UUID or timestamp-based to avoid collisions

### Attachment Files (Chat)

- **Accepted Types**: Any (validate on client)
- **Max Size**: 10MB per file
- **Max Files**: 5 per message

---

## Appendix D: Rate Limiting (Recommended)

| Endpoint Category | Rate Limit |
|-------------------|------------|
| Public APIs | 100 req/min per IP |
| Auth endpoints | 20 req/min per IP |
| Authenticated APIs | 60 req/min per user |
| File uploads | 10 req/min per user |
| WebSocket | 50 messages/min per connection |

---

## Appendix E: Error Codes

| HTTP Status | Meaning | Common Causes |
|-------------|---------|---------------|
| 200 | OK | Successful request |
| 201 | Created | Resource created successfully |
| 400 | Bad Request | Invalid input, validation errors |
| 401 | Unauthorized | Missing or invalid JWT |
| 403 | Forbidden | Insufficient permissions (e.g., non-ADMIN) |
| 404 | Not Found | Resource doesn't exist |
| 409 | Conflict | Duplicate resource (e.g., username taken) |
| 413 | Payload Too Large | File size exceeds limit |
| 429 | Too Many Requests | Rate limit exceeded |
| 500 | Internal Server Error | Server-side error |

---

**End of Specification**
