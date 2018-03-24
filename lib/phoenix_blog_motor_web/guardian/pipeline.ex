defmodule PhoenixBlogMotorWeb.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :phoenix_blog_motor,
                              module: PhoenixBlogMotorWeb.Guardian,
                              error_handler: PhoenixBlogMotorWeb.Guardian.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
  plug :set_user

  def set_user(conn, _) do
    conn
      |> Plug.Conn.assign(:user,  Guardian.Plug.current_resource(conn))
  end
end
