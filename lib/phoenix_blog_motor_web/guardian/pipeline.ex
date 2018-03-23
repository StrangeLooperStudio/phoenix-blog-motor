defmodule PhoenixBlogMotorWeb.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :phoenix_blog_motor,
                              module: PhoenixBlogMotorWeb.Guardian,
                              error_handler: PhoenixBlogMotorWeb.Guardian.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
end
