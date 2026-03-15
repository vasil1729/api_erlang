-module(youtube_h).
-behaviour(cowboy_handler).
-export([init/2]).

%% Handles 7 routes from API_SPEC 2.10:
%%
%% TODO: [channel]         GET /api/v1/public/youtube/channel - return channel object
%% TODO: [playlists]       GET /api/v1/public/youtube/playlists - paginated playlist list
%% TODO: [playlist_detail] GET /api/v1/public/youtube/playlists/:playlistId - playlist with items
%% TODO: [videos]          GET /api/v1/public/youtube/videos - paginated, sortBy, query
%% TODO: [video_detail]    GET /api/v1/public/youtube/videos/:videoId - single video or 404
%% TODO: [comments]        GET /api/v1/public/youtube/comments/:videoId - video comments
%% TODO: [related]         GET /api/v1/public/youtube/related/:videoId - related videos

init(Req0, State) ->
    %% TODO: implement
    {ok, Req0, State}.
