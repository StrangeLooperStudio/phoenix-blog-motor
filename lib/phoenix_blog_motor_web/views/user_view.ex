defmodule PhoenixBlogMotorWeb.UserView do
  use PhoenixBlogMotorWeb, :view
  alias PhoenixBlogMotorWeb.UserView

  location "/api/users/:id"

  attributes [:name, :email]
end
