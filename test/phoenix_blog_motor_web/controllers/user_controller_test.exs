defmodule PhoenixBlogMotorWeb.UserControllerTest do
  use PhoenixBlogMotorWeb.ConnCase

  alias PhoenixBlogMotor.Admin
  alias PhoenixBlogMotor.Admin.User
  alias PhoenixBlogMotorWeb.Guardian

  @create_attrs %{
    email: "test@test.com",
    name: "tester mctesterson",
    password: "test"
  }
  @update_attrs %{
    email: "test2@test.com"
  }
  @invalid_attrs %{
    email: ""
  }

  def fixture(:user) do
    {:ok, user} = Admin.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    user = fixture(:user)
    {:ok, token, _} = Guardian.encode_and_sign(user, %{}, token_type: :access)
    conn = conn
    |> put_req_header("authorization", "bearer: " <> token)
    |> put_req_header("accept", "application/json")

    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get conn, user_path(conn, :index)
      assert json_response(conn, 200)["data"] == Admin.list_users() |> Enum.map(fn x -> %{"id" => x.id} end)
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn2 = post conn, user_path(conn, :create), user: @create_attrs
      assert %{"id" => id} = json_response(conn2, 201)["data"]

      conn3 = get conn, user_path(conn, :show, id)
      assert json_response(conn3, 200)["data"] == %{
        "id" => id}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn2 = put conn, user_path(conn, :update, user), user: @update_attrs
      assert %{"id" => ^id} = json_response(conn2, 200)["data"]

      conn3 = get conn, user_path(conn, :show, id)
      assert json_response(conn3, 200)["data"] == %{
        "id" => id}
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn2 = delete conn, user_path(conn, :delete, user)
      assert response(conn2, 204)
      assert_error_sent 404, fn ->
        get conn, user_path(conn, :show, user)
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
