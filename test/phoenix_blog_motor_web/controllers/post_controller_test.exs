defmodule PhoenixBlogMotorWeb.PostControllerTest do
  use PhoenixBlogMotorWeb.ConnCase

  alias PhoenixBlogMotor.Admin
  alias PhoenixBlogMotor.Posts
  alias PhoenixBlogMotor.Posts.Post
  alias PhoenixBlogMotorWeb.Guardian

  @user_attrs %{
    email: "test@test.com",
    name: "tester mctesterson",
    password: "test"
  }

  @create_attrs %{
    title: "test title",
    body: "test body"
  }
  @update_attrs %{
    title: "test2 title"
  }
  @invalid_attrs %{
    title: ""
  }

  def fixture(:post) do
    {:ok, post} = Posts.create_post(@create_attrs)
    post
  end

  def fixture(:user) do
    {:ok, user} = Admin.create_user(@user_attrs)
    user
  end

  setup %{conn: conn} do
    conn = conn
    |> put_req_header("accept", "application/vnd.api+json")
    |> put_req_header("content-type", "application/vnd.api+json")
    {:ok, conn: conn}
  end

  describe "index with auth" do
    setup [:auth]

    test "lists all posts for admin with pagination", %{conn: conn} do
      conn = get conn, post_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end

    test "lists published posts for admin with pagination", %{conn: conn} do
      conn = get conn, post_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "index without auth" do
    test "lists published posts for guests with pagination", %{conn: conn} do
      conn = get conn, post_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create post with auth" do
    setup [:auth]

    test "renders post when data is valid", %{conn: conn} do
      conn = post conn, post_path(conn, :create), post: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, post_path(conn, :show, id)
      assert json_response(conn, 200) == JaSerializer.format(PhoenixBlogMotorWeb.PostView, Posts.get_post!(id))
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, post_path(conn, :create), post: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "create post without auth" do
    test "does not allow guests to create posts", %{conn: conn} do
      conn = post conn, post_path(conn, :create), post: @create_attrs
      assert json_response(conn, 401)
    end
  end


  describe "update post" do
    setup [:auth, :create_post]

    test "renders post when data is valid", %{conn: conn, post: %Post{id: id} = post} do
      conn = put conn, post_path(conn, :update, post), post: @update_attrs
      assert json_response(conn, 200) == JaSerializer.format(PhoenixBlogMotorWeb.PostView, Posts.get_post!(id))

      conn = get conn, post_path(conn, :show, id)
      assert json_response(conn, 200) == JaSerializer.format(PhoenixBlogMotorWeb.PostView, Posts.get_post!(id))
    end

    test "renders errors when data is invalid", %{conn: conn, post: post} do
      conn = put conn, post_path(conn, :update, post), post: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update post without auth" do
    setup [:create_post]

    test "does not allow guests to update posts", %{conn: conn, post: post} do
      conn = put conn, post_path(conn, :update, post), post: @update_attrs
      assert json_response(conn, 401)
    end
  end

  describe "delete post" do
    setup [:auth, :create_post]

    test "deletes chosen post", %{conn: conn, post: post} do
      conn = delete conn, post_path(conn, :delete, post)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, post_path(conn, :show, post)
      end
    end
  end

  describe "delete post without auth" do
    setup [:create_post]
    test "does not allow guests to delete posts", %{conn: conn, post: post} do
      conn = delete conn, post_path(conn, :delete, post)
      assert response(conn, 401)
    end
  end

  defp create_post(_) do
    post = fixture(:post)
    {:ok, post: post}
  end

  defp auth %{conn: conn} do
    user = fixture(:user)
    {:ok, token, _} = Guardian.encode_and_sign(user, %{}, token_type: :access)

    conn = conn
    |> put_req_header("authorization", "bearer: " <> token)

    {:ok, conn: conn}
  end
end
