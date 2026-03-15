-module(redirect_h).
-behaviour(cowboy_handler).
-export([init/2]).

%% Handles 1 route from API_SPEC 8.6:
%% TODO: [redirect] GET /api/v1/kitchen-sink/redirect/to
%%   Query: url (required), statusCode (optional, default 302).
%%   Validate url. Reply with HTTP redirect (301/302/307/308). 400 if url missing.

init(Req0, State) ->
    %% TODO: implement
    {ok, Req0, State}.
