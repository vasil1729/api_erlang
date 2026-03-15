-module(chat_h).
-behaviour(cowboy_handler).
-export([init/2]).

%% Handles 11 routes from API_SPEC 7.1:
%% TODO: [list_chats]       GET    /api/v1/chat-app/chats - Auth, all chats where user is participant (200)
%% TODO: [available_users]  GET    /api/v1/chat-app/chats/users - Auth, all users except current (200)
%% TODO: [create_one_on_one] POST  /api/v1/chat-app/chats/c/:receiverId - Auth, get or create 1-on-1 chat (200)
%% TODO: [create_group]     POST   /api/v1/chat-app/chats/group - Auth, body: name,participants(min 2) (201)
%% TODO: [get_group]        GET    /api/v1/chat-app/chats/group/:chatId - Auth, must be participant (200)
%% TODO: [update_group]     PATCH  /api/v1/chat-app/chats/group/:chatId - Auth, admin only, body: name (200), emit WS updateGroupName
%% TODO: [delete_group]     DELETE /api/v1/chat-app/chats/group/:chatId - Auth, admin only, delete messages, emit WS leaveChat (200)
%% TODO: [add_participant]  POST   /api/v1/chat-app/chats/group/:chatId/:participantId - Auth, admin, emit WS newChat (200)
%% TODO: [remove_participant] DELETE /api/v1/chat-app/chats/group/:chatId/:participantId - Auth, admin, emit WS leaveChat (200)
%% TODO: [leave_group]      DELETE /api/v1/chat-app/chats/leave/group/:chatId - Auth, reassign admin if needed, emit WS (200)
%% TODO: [delete_one_on_one] DELETE /api/v1/chat-app/chats/remove/:chatId - Auth, 1-on-1 only, delete messages (200)

init(Req0, State) ->
    %% TODO: implement
    {ok, Req0, State}.
