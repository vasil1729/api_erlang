-module(message_model).
-export([get_messages/2, send_message/3, delete_message/3]).
%% TODO: Collection: <<"chat_messages">>
%% get_messages(UserId, ChatId) -> [Message]  must be participant, populate sender
%% send_message(UserId, ChatId, Data) -> {ok, Message}  Data has content, attachments
%%   Update lastMessage on chat. Emit WS messageReceived via freeapi_chat_registry.
%% delete_message(UserId, ChatId, MessageId) -> ok  must be sender
%%   Update lastMessage if needed. Emit WS messageDeleted.
get_messages(_UserId, _ChatId) -> erlang:error(not_implemented).
send_message(_UserId, _ChatId, _Data) -> erlang:error(not_implemented).
delete_message(_UserId, _ChatId, _MessageId) -> erlang:error(not_implemented).
