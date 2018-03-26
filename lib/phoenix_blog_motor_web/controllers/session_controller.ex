defmodule PhoenixBlogMotorWeb.SessionController do
  use PhoenixBlogMotorWeb, :controller

  alias PhoenixBlogMotor.Admin
  alias PhoenixBlogMotor.Admin.User

  action_fallback PhoenixBlogMotorWeb.FallbackController

  def create(conn, %{"session" => session_params}) do
    with %User{} = user <- Admin.get_user_by_email!(session_params["email"]),
         { :ok } <- PhoenixBlogMotorWeb.Guardian.authenticate(%{user: user, password: session_params["password"]}) do

      conn = Guardian.Plug.sign_in(conn, PhoenixBlogMotorWeb.Guardian, user)

      render conn, "show.json-api", data: %{ token: Guardian.Plug.current_token(conn) }, user: user
    end
  end

  def show(conn, _params) do
    render conn, "show.json-api",  data: %{ id: 1, token: Guardian.Plug.current_token(conn)}
  end

  def delete(conn, _params) do
    Guardian.Plug.sign_out(conn, PhoenixBlogMotorWeb.Guardian, [])
    send_resp(conn, :no_content, "")
  end
end
