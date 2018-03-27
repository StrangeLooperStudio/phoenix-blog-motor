defmodule PhoenixBlogMotorWeb.Router do
  use PhoenixBlogMotorWeb, :router

  pipeline :api do
    plug :accepts, ["json-api"]
    plug JaSerializer.ContentTypeNegotiation
    plug JaSerializer.Deserializer
  end

  pipeline :api_auth do
    plug PhoenixBlogMotorWeb.Guardian.AuthPipeline
  end

  scope "/api", PhoenixBlogMotorWeb do
    pipe_through :api
    get "/admin/status", AdminController, :status
    resources "/session", SessionController, only: [:create], singleton: true
    resources "/post", PostController, only: [:show, :index]
  end

  scope "/api", PhoenixBlogMotorWeb do
    pipe_through [:api, :api_auth]
    resources "/users", UserController
    resources "/session", SessionController, only: [:show, :delete], singleton: true
    resources "/post", PostController, only: [:create, :update, :delete]
  end
end
