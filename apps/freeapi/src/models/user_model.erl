-module(user_model).

-export([create/1, find_by_id/1, find_by_email/1, find_by_username/1,
         update/2, delete/1, set_refresh_token/2, clear_refresh_token/1,
         set_email_verified/1, set_forgot_password_token/2,
         clear_forgot_password_token/1, update_password/2,
         update_avatar/2, update_role/2, find_all_except/1,
         hash_password/1, verify_password/2]).

%% TODO: Collection: <<"users">>
%%
%% create(UserData) -> {ok, User} | {error, duplicate_username | duplicate_email}
%%   UserData = #{username, email, password, role}
%%   Hash password with bcrypt before insert. Set defaults: isEmailVerified=false, loginType=EMAIL_PASSWORD
%%   Generate emailVerificationToken + expiry (24h). Auto-create avatar with default URL.
%%
%% find_by_id(UserId) -> {ok, User} | not_found
%%   Exclude password, refreshToken from returned doc
%%
%% find_by_email(Email) -> {ok, User} | not_found
%%   Include password hash for login verification
%%
%% find_by_username(Username) -> {ok, User} | not_found
%%
%% update(UserId, Updates) -> {ok, User} | not_found
%% delete(UserId) -> ok | not_found
%%
%% set_refresh_token(UserId, HashedToken) -> ok
%% clear_refresh_token(UserId) -> ok
%%
%% set_email_verified(UserId) -> ok
%%   Set isEmailVerified=true, clear emailVerificationToken+expiry
%%
%% set_forgot_password_token(UserId, {HashedToken, Expiry}) -> ok
%% clear_forgot_password_token(UserId) -> ok
%%
%% update_password(UserId, HashedPassword) -> ok
%% update_avatar(UserId, AvatarMap) -> {ok, User}
%% update_role(UserId, Role) -> {ok, User}
%%
%% find_all_except(UserId) -> [User]
%%   Return all users except the given one (for chat available users)
%%
%% hash_password(PlainText) -> HashedBinary
%%   Use bcrypt with salt rounds=12
%%
%% verify_password(PlainText, Hash) -> boolean()

hash_password(_Plain) -> erlang:error(not_implemented).
verify_password(_Plain, _Hash) -> erlang:error(not_implemented).
create(_Data) -> erlang:error(not_implemented).
find_by_id(_Id) -> erlang:error(not_implemented).
find_by_email(_Email) -> erlang:error(not_implemented).
find_by_username(_Username) -> erlang:error(not_implemented).
update(_Id, _Updates) -> erlang:error(not_implemented).
delete(_Id) -> erlang:error(not_implemented).
set_refresh_token(_Id, _Token) -> erlang:error(not_implemented).
clear_refresh_token(_Id) -> erlang:error(not_implemented).
set_email_verified(_Id) -> erlang:error(not_implemented).
set_forgot_password_token(_Id, _TokenExpiry) -> erlang:error(not_implemented).
clear_forgot_password_token(_Id) -> erlang:error(not_implemented).
update_password(_Id, _Hash) -> erlang:error(not_implemented).
update_avatar(_Id, _Avatar) -> erlang:error(not_implemented).
update_role(_Id, _Role) -> erlang:error(not_implemented).
find_all_except(_Id) -> erlang:error(not_implemented).
