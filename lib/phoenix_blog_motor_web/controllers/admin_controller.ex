defmodule PhoenixBlogMotorWeb.AdminController do
  use PhoenixBlogMotorWeb, :controller

  def status(conn, _params) do
    render conn, "status.json"
  end
end
