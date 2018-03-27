defmodule PhoenixBlogMotor.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :body, :string
      add :is_published, :boolean
      add :published_at, :timestamp

      add :author_id, references(:users)
      add :next_post_id, references(:posts)
      add :previous_post_id, references(:posts)

      timestamps()
    end

  end
end
