-module(user_h).
-behaviour(cowboy_handler).
-export([init/2]).

%% Handles 16 routes from API_SPEC section 3:
%%
%% TODO: [register]           POST /api/v1/users/register
%%   No auth. Body: username, email, password, role(optional).
%%   Validate uniqueness. Hash password with bcrypt. Create user.
%%   Generate access+refresh tokens. Return user+tokens (201).
%%
%% TODO: [login]              POST /api/v1/users/login
%%   No auth. Body: email, password. Verify with bcrypt.
%%   Generate tokens. Return user+tokens (200).
%%
%% TODO: [refresh_token]      POST /api/v1/users/refresh-token
%%   No auth. Body: refreshToken. Validate, generate new pair. Return tokens (200).
%%
%% TODO: [verify_email]       GET /api/v1/users/verify-email/:verificationToken
%%   No auth. Hash token with SHA256, find user, set isEmailVerified=true. (200)
%%
%% TODO: [forgot_password]    POST /api/v1/users/forgot-password
%%   No auth. Body: email. Generate reset token, store hash+expiry, send email. (200)
%%
%% TODO: [reset_password]     POST /api/v1/users/reset-password/:resetToken
%%   No auth. Body: newPassword. Hash token, find user, update password. (200)
%%
%% TODO: [logout]             POST /api/v1/users/logout
%%   Auth required. Clear refreshToken in DB. (200)
%%
%% TODO: [update_avatar]      PATCH /api/v1/users/avatar
%%   Auth required. Multipart: avatar file (max 2MB, image/*). Save file, update user. (200)
%%
%% TODO: [current_user]       GET /api/v1/users/current-user
%%   Auth required. Return current user from JWT (without password/tokens). (200)
%%
%% TODO: [change_password]    POST /api/v1/users/change-password
%%   Auth required. Body: oldPassword, newPassword. Verify old, hash new, update. (200)
%%
%% TODO: [resend_verification] POST /api/v1/users/resend-email-verification
%%   Auth required. Generate new verification token, send email. (200)
%%
%% TODO: [assign_role]        POST /api/v1/users/assign-role/:userId
%%   Admin only. Body: role (ADMIN|USER). Update target user's role. (200)
%%
%% TODO: [google_redirect]    GET /api/v1/users/google
%%   No auth. Redirect to Google OAuth consent screen. (302)
%%
%% TODO: [github_redirect]    GET /api/v1/users/github
%%   No auth. Redirect to GitHub OAuth consent screen. (302)
%%
%% TODO: [google_callback]    GET /api/v1/users/google/callback
%%   No auth. Exchange code for token, fetch user, create/find user, redirect with tokens. (302)
%%
%% TODO: [github_callback]    GET /api/v1/users/github/callback
%%   No auth. Same as google_callback but for GitHub. (302)

init(Req0, State) ->
    %% TODO: pattern match on State to dispatch each action
    {ok, Req0, State}.
