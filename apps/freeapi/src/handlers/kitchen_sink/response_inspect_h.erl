-module(response_inspect_h).
-behaviour(cowboy_handler).
-export([init/2]).

%% Handles 6 routes from API_SPEC 8.4:
%% TODO: [cache]  GET /api/v1/kitchen-sink/response/cache/:timeToLive/:cacheResponseDirective
%%   Set Cache-Control header: {directive}, max-age={ttl}. Return 200.
%% TODO: [headers] GET /api/v1/kitchen-sink/response/headers - return response headers (200)
%% TODO: [html]    GET /api/v1/kitchen-sink/response/html - Content-Type: text/html, return HTML template (200)
%% TODO: [xml]     GET /api/v1/kitchen-sink/response/xml - Content-Type: text/xml, return XML (200)
%% TODO: [gzip]    GET /api/v1/kitchen-sink/response/gzip - Content-Encoding: gzip, return gzip-compressed body (200)
%% TODO: [brotli]  GET /api/v1/kitchen-sink/response/brotli - Content-Encoding: br, return brotli-compressed body (200)

init(Req0, State) ->
    %% TODO: implement
    {ok, Req0, State}.
