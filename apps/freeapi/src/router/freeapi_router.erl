-module(freeapi_router).

-export([dispatch/0]).

%% TODO: Implement dispatch/0
%% Build and return cowboy_router:compile/1 dispatch table for ALL 168 routes.
%% Use cowboy_router:compile([{'_', Routes}]) format.
%%
%% Route format: {PathMatch, Handler, Opts}
%% where Opts is an atom or tuple identifying the action.
%%
%% === Routes to register (168 total) ===
%%
%% --- Healthcheck (1) ---
%% GET  /api/v1/healthcheck -> healthcheck_h, []
%%
%% --- Public APIs (34) ---
%% GET  /api/v1/public/randomusers                    -> randomuser_h, [list]
%% GET  /api/v1/public/randomusers/user/random         -> randomuser_h, [random]
%% GET  /api/v1/public/randomusers/:userId             -> randomuser_h, [get_one]
%% GET  /api/v1/public/randomproducts                  -> randomproduct_h, [list]
%% GET  /api/v1/public/randomproducts/product/random   -> randomproduct_h, [random]
%% GET  /api/v1/public/randomproducts/:productId       -> randomproduct_h, [get_one]
%% GET  /api/v1/public/randomjokes                     -> randomjoke_h, [list]
%% GET  /api/v1/public/randomjokes/joke/random         -> randomjoke_h, [random]
%% GET  /api/v1/public/randomjokes/:jokeId             -> randomjoke_h, [get_one]
%% GET  /api/v1/public/books                           -> book_h, [list]
%% GET  /api/v1/public/books/book/random               -> book_h, [random]
%% GET  /api/v1/public/books/:bookId                   -> book_h, [get_one]
%% GET  /api/v1/public/quotes                          -> quote_h, [list]
%% GET  /api/v1/public/quotes/quote/random             -> quote_h, [random]
%% GET  /api/v1/public/quotes/:quoteId                 -> quote_h, [get_one]
%% GET  /api/v1/public/meals                           -> meal_h, [list]
%% GET  /api/v1/public/meals/meal/random               -> meal_h, [random]
%% GET  /api/v1/public/meals/:mealId                   -> meal_h, [get_one]
%% GET  /api/v1/public/dogs                            -> dog_h, [list]
%% GET  /api/v1/public/dogs/dog/random                 -> dog_h, [random]
%% GET  /api/v1/public/dogs/:dogId                     -> dog_h, [get_one]
%% GET  /api/v1/public/cats                            -> cat_h, [list]
%% GET  /api/v1/public/cats/cat/random                 -> cat_h, [random]
%% GET  /api/v1/public/cats/:catId                     -> cat_h, [get_one]
%% GET  /api/v1/public/stocks                          -> stock_h, [list]
%% GET  /api/v1/public/stocks/stock/random             -> stock_h, [random]
%% GET  /api/v1/public/stocks/:stockSymbol             -> stock_h, [get_one]
%% GET  /api/v1/public/youtube/channel                 -> youtube_h, [channel]
%% GET  /api/v1/public/youtube/playlists               -> youtube_h, [playlists]
%% GET  /api/v1/public/youtube/playlists/:playlistId   -> youtube_h, [playlist_detail]
%% GET  /api/v1/public/youtube/videos                  -> youtube_h, [videos]
%% GET  /api/v1/public/youtube/videos/:videoId         -> youtube_h, [video_detail]
%% GET  /api/v1/public/youtube/comments/:videoId       -> youtube_h, [comments]
%% GET  /api/v1/public/youtube/related/:videoId        -> youtube_h, [related]
%%
%% --- Auth (16) ---
%% POST  /api/v1/users/register                        -> user_h, [register]
%% POST  /api/v1/users/login                           -> user_h, [login]
%% POST  /api/v1/users/refresh-token                   -> user_h, [refresh_token]
%% GET   /api/v1/users/verify-email/:verificationToken -> user_h, [verify_email]
%% POST  /api/v1/users/forgot-password                 -> user_h, [forgot_password]
%% POST  /api/v1/users/reset-password/:resetToken      -> user_h, [reset_password]
%% POST  /api/v1/users/logout                          -> user_h, [logout]
%% PATCH /api/v1/users/avatar                          -> user_h, [update_avatar]
%% GET   /api/v1/users/current-user                    -> user_h, [current_user]
%% POST  /api/v1/users/change-password                 -> user_h, [change_password]
%% POST  /api/v1/users/resend-email-verification       -> user_h, [resend_verification]
%% POST  /api/v1/users/assign-role/:userId             -> user_h, [assign_role]
%% GET   /api/v1/users/google                          -> user_h, [google_redirect]
%% GET   /api/v1/users/github                          -> user_h, [github_redirect]
%% GET   /api/v1/users/google/callback                 -> user_h, [google_callback]
%% GET   /api/v1/users/github/callback                 -> user_h, [github_callback]
%%
%% --- Todo (7) ---
%% GET    /api/v1/todos                                -> todo_h, [list]
%% POST   /api/v1/todos                                -> todo_h, [create]
%% GET    /api/v1/todos/toggle/status/:todoId           -> todo_h, [toggle_status]  (PATCH)
%% GET    /api/v1/todos/:todoId                        -> todo_h, [get_one]
%% PATCH  /api/v1/todos/:todoId                        -> todo_h, [update]
%% DELETE /api/v1/todos/:todoId                        -> todo_h, [delete]
%% PATCH  /api/v1/todos/toggle/status/:todoId          -> todo_h, [toggle_status]
%%
%% --- E-commerce (40) ---
%% (Categories 5, Addresses 5, Products 7, Profile 3, Cart 4, Orders 7, Coupons 9)
%% See API_SPEC.md sections 5.1-5.7 for complete list
%%
%% --- Social Media (24) ---
%% (Profile 4, Follow 3, Posts 9, Likes 2, Bookmarks 2, Comments 4)
%% See API_SPEC.md section 6 for complete list
%%
%% --- Chat App (14) ---
%% (Chats 11, Messages 3)
%% See API_SPEC.md section 7 for complete list
%%
%% --- Kitchen Sink (27) ---
%% (HTTP Methods 5, Status Codes 2, Request Inspection 5, Response Inspection 6,
%%  Cookies 3, Redirect 1, Images 5)
%% See API_SPEC.md section 8 for complete list
%%
%% --- Seeding & Admin (5) ---
%% GET    /api/v1/seed/generated-credentials -> seed_h, [credentials]
%% POST   /api/v1/seed/todos                -> seed_h, [seed_todos]
%% POST   /api/v1/seed/ecommerce            -> seed_h, [seed_ecommerce]
%% POST   /api/v1/seed/social-media         -> seed_h, [seed_social]
%% POST   /api/v1/seed/chat-app             -> seed_h, [seed_chat]
%% DELETE /api/v1/reset-db                  -> seed_h, [reset_db]

dispatch() ->
    %% TODO: implement full dispatch table
    cowboy_router:compile([{'_', []}]).
