-module(chat_ws_h).

-export([init/2, websocket_init/1, websocket_handle/2, websocket_info/2, terminate/3]).

%% TODO: Implement WebSocket handler for real-time chat (API_SPEC Appendix A)
%%
%% init/2: Upgrade to WebSocket. Extract auth token from query param or first message.
%%   {cowboy_websocket, Req, State, #{idle_timeout => 300000}}
%%
%% websocket_init/1: Authenticate user, join their chat rooms via freeapi_chat_registry
%%
%% websocket_handle/2: Handle incoming WebSocket frames:
%%   - {text, JSON} -> decode and handle events:
%%     * "sendMessage": {chatId, content, attachments} -> save message, broadcast via registry
%%     * "typing": {chatId, isTyping} -> broadcast typing indicator
%%
%% websocket_info/2: Handle Erlang messages from other processes:
%%   - {ws_send, Event} -> encode as JSON text frame, send to client
%%     Events: messageReceived, messageDeleted, updateGroupName, leaveChat, newChat, userTyping
%%
%% terminate/3: Unregister from freeapi_chat_registry

init(Req, State) ->
    {cowboy_websocket, Req, State, #{idle_timeout => 300000}}.

websocket_init(State) ->
    %% TODO: authenticate and join chat rooms
    {ok, State}.

websocket_handle({text, _Json}, State) ->
    %% TODO: parse and handle events
    {ok, State};
websocket_handle(_Frame, State) ->
    {ok, State}.

websocket_info({ws_send, Event}, State) ->
    %% TODO: encode and send
    Json = jiffy:encode(Event),
    {reply, {text, Json}, State};
websocket_info(_Info, State) ->
    {ok, State}.

terminate(_Reason, _Req, _State) ->
    %% TODO: unregister from chat registry
    ok.
