-module(freeapi_chat_registry).
-behaviour(gen_server).

-export([start_link/0]).
-export([join/3, leave/2, broadcast/3, get_members/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% TODO: Implement WebSocket pid registry for chat rooms
%%
%% State: #{ChatId => #{Pid => UserInfo}}
%%
%% join(ChatId, Pid, UserInfo) -> ok
%%   Register a WebSocket process pid for a chat room
%%   Monitor the pid for automatic cleanup on disconnect
join(_ChatId, _Pid, _UserInfo) -> erlang:error(not_implemented).

%% leave(ChatId, Pid) -> ok
%%   Unregister a WebSocket process pid from a chat room
leave(_ChatId, _Pid) -> erlang:error(not_implemented).

%% broadcast(ChatId, SenderPid, Event) -> ok
%%   Send Event to all pids in ChatId except SenderPid
%%   Each recipient pid receives {ws_send, Event} message
broadcast(_ChatId, _SenderPid, _Event) -> erlang:error(not_implemented).

%% get_members(ChatId) -> [#{pid => Pid, user => UserInfo}]
get_members(_ChatId) -> erlang:error(not_implemented).

init([]) ->
    {ok, #{}}.

handle_call(_Request, _From, State) -> {reply, ok, State}.
handle_cast(_Msg, State) -> {noreply, State}.

%% TODO: handle_info({'DOWN', _, process, Pid, _}, State)
%% Remove Pid from all chat rooms when WebSocket process dies
handle_info(_Info, State) -> {noreply, State}.
