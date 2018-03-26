defmodule PhoenixBlogMotorWeb.SessionControllerTest do
  use PhoenixBlogMotorWeb.ConnCase

  alias PhoenixBlogMotor.Admin
  alias PhoenixBlogMotorWeb.Guardian

  @create_attrs %{
    email: "test@test.com",
    name: "tester mctesterson",
    password: "test"
  }

  @invalid_attrs %{
    email: "test@test.com",
    password: "wtf"
  }

  def fixture(:user) do
    {:ok, user} = Admin.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    conn = conn
    |> put_req_header("accept", "application/vnd.api+json")
    |> put_req_header("content-type", "application/vnd.api+json")
    
    {:ok, conn: conn}
  end

  describe "create session" do
    test "renders session when user password is correct", %{conn: conn} do
      fixture(:user)
      conn2 = post conn, session_path(conn, :create), session: @create_attrs
      token = json_response(conn2, 200)["data"]["attributes"]["token"]
      assert token == Guardian.Plug.current_token(conn2)
    end

    test "renders errors when password is incorrect", %{conn: conn} do
      fixture(:user)
      conn2 = post conn, session_path(conn, :create), session: @invalid_attrs
      assert json_response(conn2, 401)
    end
  end

  describe "show session when logged in" do
    setup [:auth_headers]

    test "shows current session", %{conn: conn} do
      conn = get conn, session_path(conn, :show)
      assert json_response(conn, 200)["data"]["attributes"]["token"] == Guardian.Plug.current_token(conn)
    end
  end

  describe "show error for session when not logged in" do
    test "shows error", %{conn: conn} do
      conn = get conn, session_path(conn, :show)
      assert response(conn, 401)
    end
  end

  describe "delete session" do
    setup [:auth_headers]

    test "revokes current token", %{conn: conn} do
      conn2 = delete conn, session_path(conn, :delete)
      assert response(conn2, 204)
      conn3 = get conn2, session_path(conn, :show)
      assert response(conn3, 401)
    end
  end

  defp auth_headers(  %{conn: conn} ) do
    user = fixture(:user)
    {:ok, token, _} = Guardian.encode_and_sign(user, %{}, token_type: :access)
     conn = conn
      |> put_req_header("authorization", "bearer: " <> token)
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

     {:ok, conn: conn}
  end
end
