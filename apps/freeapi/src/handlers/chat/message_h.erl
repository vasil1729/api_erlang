-module(message_h).
-behaviour(cowboy_handler).
-export([init/2]).

%% Handles 3 routes from API_SPEC 7.2:
%% TODO: [list]   GET    /api/v1/chat-app/messages/:chatId - Auth, must be participant, populate sender (200)
%% TODO: [send]   POST   /api/v1/chat-app/messages/:chatId - Auth, multipart: content,attachments(max 5,10MB), update lastMessage, emit WS messageReceived (201)
%% TODO: [delete] DELETE /api/v1/chat-app/messages/:chatId/:messageId - Auth, sender only, emit WS messageDeleted (200)

init(Req0, State) ->
    %% TODO: implement
    {ok, Req0, State}.
