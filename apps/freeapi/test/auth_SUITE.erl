-module(auth_SUITE).
-include_lib("common_test/include/ct.hrl").
-export([all/0, init_per_suite/1, end_per_suite/1]).
-export([register_test/1, login_test/1, current_user_test/1, refresh_token_test/1,
         logout_test/1, change_password_test/1, assign_role_test/1]).

%% TODO: Test all 16 auth endpoints
%% register -> login -> current-user -> change-password -> logout -> refresh-token
%% verify-email, forgot-password, reset-password, resend-verification
%% assign-role (admin only), avatar upload
%% Google/GitHub OAuth (mock or skip)

all() -> [register_test, login_test, current_user_test, refresh_token_test,
           logout_test, change_password_test, assign_role_test].

init_per_suite(Config) -> Config.
end_per_suite(_Config) -> ok.

register_test(_Config) -> ok.
login_test(_Config) -> ok.
current_user_test(_Config) -> ok.
refresh_token_test(_Config) -> ok.
logout_test(_Config) -> ok.
change_password_test(_Config) -> ok.
assign_role_test(_Config) -> ok.
