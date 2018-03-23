defmodule PhoenixBlogMotor.Admin.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Comeonin

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :encrypted_password, :string
    field :name, :string
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :name])
    |> validate_required([:email, :name])
    |> unique_constraint(:email)
    |> put_password_hash
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        change(changeset, %{
          encrypted_password: Comeonin.Argon2.hashpwsalt(pass),
          password: nil
        })
      _ ->
        changeset
    end
  end
end
