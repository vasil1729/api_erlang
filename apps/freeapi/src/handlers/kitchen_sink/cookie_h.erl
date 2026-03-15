-module(cookie_h).
-behaviour(cowboy_handler).
-export([init/2]).

%% Handles 3 routes from API_SPEC 8.5:
%% TODO: [get_cookies]    GET    /api/v1/kitchen-sink/cookies/get - return all request cookies (200)
%% TODO: [set_cookie]     POST   /api/v1/kitchen-sink/cookies/set - body: name,value,maxAge,httpOnly,secure,sameSite. Set-Cookie header (200)
%% TODO: [remove_cookie]  DELETE /api/v1/kitchen-sink/cookies/remove - body: name. Set-Cookie with expired maxAge (200)

init(Req0, State) ->
    %% TODO: implement
    {ok, Req0, State}.
