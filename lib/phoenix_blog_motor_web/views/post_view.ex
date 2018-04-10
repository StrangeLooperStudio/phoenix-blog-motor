defmodule PhoenixBlogMotorWeb.PostView do
  use PhoenixBlogMotorWeb, :view
  alias PhoenixBlogMotor.Repo

  location "/api/session"

  attributes [:title, :body, :is_published, :published_at]

  has_one :next_post, serializer: PhoenixBlogMotorWeb.PostView
  has_one :previous_post, serializer: PhoenixBlogMotorWeb.PostView

  has_one :author, serializer: PhoenixBlogMotorWeb.UserView

  def author(struct, _conn) do
    case struct.author do
      %Ecto.Association.NotLoaded{} ->
        struct
        |> Ecto.assoc(:author)
        |> Repo.all
      other -> other
    end
  end

  def next_post(struct, _conn) do
    case struct.author do
      %Ecto.Association.NotLoaded{} ->
        struct
        |> Ecto.assoc(:next_post)
        |> Repo.all
      other -> other
    end
  end

  def previous_post(struct, _conn) do
    case struct.author do
      %Ecto.Association.NotLoaded{} ->
        struct
        |> Ecto.assoc(:previous_post)
        |> Repo.all
      other -> other
    end
  end

end
