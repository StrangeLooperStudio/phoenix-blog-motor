defmodule PhoenixBlogMotorWeb.SessionView do
  use PhoenixBlogMotorWeb, :view
  alias PhoenixBlogMotorWeb.SessionView

  def render("session.json-api", %{token: token, user: user}) do
    %{
      data: %{
        id: 1,
        type: "sessions",
        attributes: %{
          token: token
        },
        relationships: %{
          user: %{
            type: "users",
            id: user.id
          }
        }
      }
    }
  end
end
