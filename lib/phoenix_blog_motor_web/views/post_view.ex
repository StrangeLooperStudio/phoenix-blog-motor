defmodule PhoenixBlogMotorWeb.PostView do
  use PhoenixBlogMotorWeb, :view

  location "/api/session"

  attributes [:title, :body, :is_published, :published_at]

  has_one :next_post, serializer: PhoenixBlogMotorWeb.PostView
  has_one :previous_post, serializer: PhoenixBlogMotorWeb.PostView

  has_one :author, serializer: PhoenixBlogMotorWeb.UserView

end
