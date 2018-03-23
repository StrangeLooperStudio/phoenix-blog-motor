# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :phoenix_blog_motor,
  ecto_repos: [PhoenixBlogMotor.Repo]

# Configure Guradian
config :phoenix_blog_motor, PhoenixBlogMotorWeb.Guardian,
  issuer: "phoenix_blog_motor",
  secret_key: "ge1P67O2lwWoxYmGhK7vUh9jB2lFilr8JSWkhRlRw5x9Zo60IhQaI+KjYqrWj/j5"

# Configures the endpoint
config :phoenix_blog_motor, PhoenixBlogMotorWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "sRjeabLCvFfJglGAOnku+NIkarOH7LlVWlPFK8/fAF5pII0iPmSaD9/d/mCY4rl/",
  render_errors: [view: PhoenixBlogMotorWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: PhoenixBlogMotor.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
