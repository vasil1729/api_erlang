-module(upload_service).

-export([read_multipart/2, save_file/2, delete_file/1, allowed_image_type/1]).

%% TODO: Implement file upload handling with cowboy multipart API
%%
%% read_multipart(Req, MaxSize) -> {ok, FileData, Req1} | {done, Req1} | {error, too_large}
%%   FileData = #{field => binary(), filename => binary(),
%%                content_type => binary(), data => binary()}
%%   Read multipart body using cowboy_req:read_part/1 and cowboy_req:read_part_body/2
read_multipart(_Req, _MaxSize) -> erlang:error(not_implemented).

%% save_file(FileData, SubDir) -> {ok, #{url => binary(), local_path => binary()}}
%%   SubDir examples: <<"avatars">>, <<"products">>, <<"posts">>, <<"attachments">>
%%   Generate UUID-based filename to avoid collisions
%%   Save to {upload_dir}/{SubDir}/{uuid}{ext}
%%   Return public URL path and local filesystem path
save_file(_FileData, _SubDir) -> erlang:error(not_implemented).

%% delete_file(LocalPath) -> ok
%%   Delete a previously uploaded file from disk
%%   Silently ignore if file doesn't exist
delete_file(_LocalPath) -> erlang:error(not_implemented).

%% allowed_image_type(ContentType) -> boolean()
%%   Returns true for image/jpeg, image/png, image/webp
allowed_image_type(_ContentType) -> erlang:error(not_implemented).
