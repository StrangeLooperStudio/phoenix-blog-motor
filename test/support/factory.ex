defmodule PhoenixBlogMotor.Factory do
  use ExMachina.Ecto, repo: PhoenixBlogMotor.Repo
  alias  PhoenixBlogMotor.Admin.User
  alias  PhoenixBlogMotor.Posts.Post

  def user_factory do
    %User{
      name: Faker.Name.name,
      email: Faker.Internet.email
    }
  end

  def post_factory() do
    %Post{
      title: Faker.Lorem.sentence,
      body: Faker.Lorem.paragraph
      # associations are inserted when you call `insert`
    }
  end
end
