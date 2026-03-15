-module(book_h).
-behaviour(cowboy_handler).
-export([init/2]).

%% Handles 3 routes from API_SPEC 2.4:
%% TODO: [list]    GET /api/v1/public/books - paginated, query search in title, inc fields
%% TODO: [get_one] GET /api/v1/public/books/:bookId - single or 404
%% TODO: [random]  GET /api/v1/public/books/book/random - random book

init(Req0, State) ->
    %% TODO: implement
    {ok, Req0, State}.
