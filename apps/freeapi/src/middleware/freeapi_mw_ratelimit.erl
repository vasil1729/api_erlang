-module(freeapi_mw_ratelimit).

-export([check/2]).

%% TODO: Implement rate limiting
%% Use an ETS table (or counters) to track request counts per IP or user.
%%
%% Rate limit tiers (from API_SPEC.md Appendix D):
%%   - public_apis:      100 req/min per IP
%%   - auth_endpoints:    20 req/min per IP
%%   - authenticated:     60 req/min per user
%%   - file_uploads:      10 req/min per user
%%   - websocket:         50 messages/min per connection
%%
%% check(Category, Req) -> ok | {error, 429, Req}
%% Category :: public | auth | authenticated | upload
%%
%% Implementation approach:
%% - Create ETS table on app start: {ip_or_user, count, window_start_timestamp}
%% - On each request, check if within window; increment or reset counter
%% - Return 429 Too Many Requests if limit exceeded

check(_Category, _Req) ->
    %% TODO: implement
    ok.
