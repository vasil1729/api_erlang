-module(chat_model).
-export([get_user_chats/1, create_one_on_one/2, create_group/3,
         get_group_detail/2, update_group_name/3, delete_group/2,
         add_participant/3, remove_participant/3, leave_group/2,
         delete_one_on_one/2]).
%% TODO: Collection: <<"chats">>
%% get_user_chats(UserId) -> [Chat]  populate participants, admin, lastMessage
%% create_one_on_one(UserId, ReceiverId) -> {ok, Chat}  return existing if found
%% create_group(UserId, Name, ParticipantIds) -> {ok, Chat}  UserId becomes admin, min 2 other participants
%% get_group_detail(UserId, ChatId) -> {ok, Chat} | not_found  must be participant
%% update_group_name(UserId, ChatId, Name) -> {ok, Chat}  must be admin
%% delete_group(UserId, ChatId) -> ok  must be admin, delete all messages
%% add_participant(UserId, ChatId, ParticipantId) -> {ok, Chat}  must be admin
%% remove_participant(UserId, ChatId, ParticipantId) -> {ok, Chat}  must be admin
%% leave_group(UserId, ChatId) -> ok  reassign admin if needed
%% delete_one_on_one(UserId, ChatId) -> ok  only for non-group chats, delete messages
get_user_chats(_UserId) -> erlang:error(not_implemented).
create_one_on_one(_UserId, _ReceiverId) -> erlang:error(not_implemented).
create_group(_UserId, _Name, _Participants) -> erlang:error(not_implemented).
get_group_detail(_UserId, _ChatId) -> erlang:error(not_implemented).
update_group_name(_UserId, _ChatId, _Name) -> erlang:error(not_implemented).
delete_group(_UserId, _ChatId) -> erlang:error(not_implemented).
add_participant(_UserId, _ChatId, _ParticipantId) -> erlang:error(not_implemented).
remove_participant(_UserId, _ChatId, _ParticipantId) -> erlang:error(not_implemented).
leave_group(_UserId, _ChatId) -> erlang:error(not_implemented).
delete_one_on_one(_UserId, _ChatId) -> erlang:error(not_implemented).
