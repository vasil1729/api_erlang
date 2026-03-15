-module(image_h).
-behaviour(cowboy_handler).
-export([init/2]).

%% Handles 5 routes from API_SPEC 8.7:
%% TODO: [jpeg] GET /api/v1/kitchen-sink/image/jpeg - Content-Type: image/jpeg, serve priv/images/sample.jpeg
%% TODO: [jpg]  GET /api/v1/kitchen-sink/image/jpg  - Content-Type: image/jpeg, serve priv/images/sample.jpg
%% TODO: [png]  GET /api/v1/kitchen-sink/image/png  - Content-Type: image/png, serve priv/images/sample.png
%% TODO: [svg]  GET /api/v1/kitchen-sink/image/svg  - Content-Type: image/svg+xml, serve priv/images/sample.svg
%% TODO: [webp] GET /api/v1/kitchen-sink/image/webp - Content-Type: image/webp, serve priv/images/sample.webp

init(Req0, State) ->
    %% TODO: implement
    {ok, Req0, State}.
