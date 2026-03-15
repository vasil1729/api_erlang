-module(sm_post_h).
-behaviour(cowboy_handler).
-export([init/2]).

%% Handles 9 routes from API_SPEC 6.3:
%% TODO: [list]         GET    /api/v1/social-media/posts - Auth, paginated, include author,likesCount,commentsCount,isLiked,isBookmarked (200)
%% TODO: [create]       POST   /api/v1/social-media/posts - Auth, multipart: content,tags,images(max 6) (201)
%% TODO: [my_posts]     GET    /api/v1/social-media/posts/get/my - Auth, paginated (200)
%% TODO: [by_username]  GET    /api/v1/social-media/posts/get/u/:username - Auth, paginated (200)
%% TODO: [by_tag]       GET    /api/v1/social-media/posts/get/t/:tag - Auth, paginated (200)
%% TODO: [get_one]      GET    /api/v1/social-media/posts/:postId - Auth, full post with counts (200/404)
%% TODO: [update]       PATCH  /api/v1/social-media/posts/:postId - Auth, owner only, multipart (200)
%% TODO: [delete]       DELETE /api/v1/social-media/posts/:postId - Auth, owner only, cascade delete comments+likes+bookmarks+images (200)
%% TODO: [remove_image] PATCH  /api/v1/social-media/posts/remove/image/:postId/:imageId - Auth, owner only, delete file (200)

init(Req0, State) ->
    %% TODO: implement
    {ok, Req0, State}.
