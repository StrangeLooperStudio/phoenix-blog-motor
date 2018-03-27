defmodule PhoenixBlogMotorWeb.UserView do
  use PhoenixBlogMotorWeb, :view

  location "/api/users/:id"

  attributes [:name, :email]
end
