defmodule PhoenixBlogMotorWeb.Router do
  use PhoenixBlogMotorWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug PhoenixBlogMotorWeb.Guardian.AuthPipeline
  end

  scope "/api", PhoenixBlogMotorWeb do
    pipe_through :api
    get "/admin/status", AdminController, :status
    resources "/session", SessionController, only: [:create], singleton: true
  end

  scope "/api", PhoenixBlogMotorWeb do
    pipe_through [:api, :api_auth]
    resources "/users", UserController
    #resources "/session", SessionController, only: [:show, :delete], singleton: true
  end
end
