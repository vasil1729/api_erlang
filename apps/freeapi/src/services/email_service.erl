-module(email_service).

-export([send_verification_email/2, send_password_reset_email/2]).

%% TODO: Implement email sending (mock or real via gen_smtp)
%%
%% send_verification_email(Email, VerificationToken) -> ok | {error, Reason}
%%   In dev mode: log the verification URL to console
%%   In prod mode: send via SMTP using gen_smtp
%%   URL format: {frontend_url}/verify-email/{token}
send_verification_email(_Email, _Token) ->
    %% TODO: implement (log for now)
    ok.

%% send_password_reset_email(Email, ResetToken) -> ok | {error, Reason}
%%   URL format: {frontend_url}/reset-password/{token}
send_password_reset_email(_Email, _Token) ->
    %% TODO: implement (log for now)
    ok.
