defmodule RumblWeb.VideoControllerTest do
 use RumblWeb.ConnCase, async: true

 alias Rumbl.Multimedia

 @create_attrs %{
  title: "vid",
  url: "http://youtu.be",
  description: "a vid"
 }

 @invalid_attrs %{title: "invalid"}

 defp video_count, do: Enum.count(Multimedia.list_videos())

 @tag login_required: true
 test "creates user video and redirects", %{conn: conn, user: user} do
  create_conn =
    post conn, ~p"/manage/videos", video: @create_attrs

  assert %{id: id} = redirected_params(create_conn)
  assert redirected_to(create_conn) == ~p"/manage/videos/#{id}"

  conn = get conn, ~p"/manage/videos/#{id}"
  assert html_response(conn, 200) =~ "Video #{id}"

  assert Multimedia.get_video!(id).user_id == user.id
 end

 @tag login_required: true
 test "does not create video, renders errors when invalid", %{conn: conn, user: _user} do
  count_before = video_count()

  conn =
    post conn, ~p"/manage/videos", video: @invalid_attrs

  assert html_response(conn, 200) =~ "check the errors"
  assert video_count() == count_before
 end

 @tag login_required: true
 test "lists all user's videos on index", %{conn: conn, user: user} do
  user_video = video_fixture(user, title: "funny cats")
  other_video = video_fixture(
    user_fixture(username: "other"),
    title: "another video"
  )

  conn = get conn, ~p"/manage/videos"
  assert html_response(conn, 200) =~ ~r/Listing Videos/
  assert String.contains?(conn.resp_body, user_video.title)
  refute String.contains?(conn.resp_body, other_video.title)
 end

 test "authorizes actions against access by other users", %{conn: conn} do
  owner = user_fixture(username: "owner")
  video = video_fixture(owner, @create_attrs)
  non_owner = user_fixture(username: "sneaky")

  conn = assign(conn, :current_user, non_owner)

  assert_error_sent :not_found, fn ->
    get conn, ~p"/manage/videos/#{video.id}"
  end
  
  assert_error_sent :not_found, fn ->
    get conn, ~p"/manage/videos/#{video.id}/edit"
  end
  
  assert_error_sent :not_found, fn ->
    put conn, ~p"/manage/videos/#{video.id}", video: @create_attrs
  end
  
  assert_error_sent :not_found, fn ->
    delete conn, ~p"/manage/videos/#{video.id}"
  end
 end

 test "requires user authentication on all actions", %{conn: conn} do
  Enum.each([
    get(conn, ~p"/manage/videos/new"),
    get(conn, ~p"/manage/videos"),
    get(conn, ~p"/manage/videos/123"),
    get(conn, ~p"/manage/videos/123/edit"),
    put(conn, ~p"/manage/videos/123"),
    post(conn, ~p"/manage/videos"),
    delete(conn, ~p"/manage/videos/123"),
   ],
   fn conn ->
    assert html_response(conn, 302)
    assert conn.halted
   end
  )
 end

 setup context do
  if context[:login_required] do
    user = user_fixture(username: "user")
    conn = build_conn_login_as(user)
    {:ok, conn: conn, user: user}
  else
    conn = build_test_conn()
    {:ok, conn: conn, user: nil}
  end
 end
end
