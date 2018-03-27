defmodule PhoenixBlogMotor.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :title, :string
    field :body, :string
    field :is_published, :boolean
    field :published_at, :utc_datetime

    belongs_to :author, PhoenixBlogMotor.Admin.User
    belongs_to :next_post, PhoenixBlogMotor.Posts.Post
    belongs_to :previous_post, PhoenixBlogMotor.Posts.Post

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body, :is_published, :published_at])
    |> validate_required([:title, :body])
  end
end
