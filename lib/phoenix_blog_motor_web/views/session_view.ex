defmodule PhoenixBlogMotorWeb.SessionView do
  use PhoenixBlogMotorWeb, :view

  location "/api/session"

  attributes [:token]

  has_one :user, include: true, serializer: PhoenixBlogMotorWeb.UserView

  def user(_token, conn) do
    Guardian.Plug.current_resource(conn)
  end
end
