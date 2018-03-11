defmodule PhoenixBlogMotorWeb.Router do
  use PhoenixBlogMotorWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PhoenixBlogMotorWeb do
    pipe_through :api

    get "/admin/status", AdminController, :status
  end
end
