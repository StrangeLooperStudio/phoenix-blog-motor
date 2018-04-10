defmodule PhoenixBlogMotor.Factory do
  use ExMachina.Ecto, repo: PhoenixBlogMotor.Repo
  alias  PhoenixBlogMotor.Admin.User

  def user_factory do
    %User{
      name: "Jane Smith",
      email: sequence(:email, &"email-#{&1}@example.com")
    }
  end

  def post_factory do
    %PhoenixBlogMotor.Posts.Post{
      title: "Use ExMachina!",
      body: "Test, Test",
      # associations are inserted when you call `insert`
      author: build(:user),
    }
  end
end
