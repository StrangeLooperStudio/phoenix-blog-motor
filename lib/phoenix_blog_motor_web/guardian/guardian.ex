defmodule PhoenixBlogMotorWeb.Guardian do
  use Guardian, otp_app: :phoenix_blog_motor
  alias PhoenixBlogMotor.Admin
  import Comeonin

  def subject_for_token(resource, _claims) do
    # You can use any value for the subject of your token but
    # it should be useful in retrieving the resource later, see
    # how it being used on `resource_from_claims/1` function.
    # A unique `id` is a good subject, a non-unique email address
    # is a poor subject.
    sub = to_string(resource.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    # Here we'll look up our resource from the claims, the subject can be
    # found in the `"sub"` key. In `above subject_for_token/2` we returned
    # the resource id so here we'll rely on that to look it up.
    id = claims["sub"]
    resource = Admin.get_user!(id)
    {:ok,  resource}
  end

  @doc """
  Returns a `%Guardian.Token{}` on successful password auth.

  ## Examples

      iex> authenticate(%{user, password})
      %Guardian.Token{}

  """
  def authenticate(%{user: user, password: password}) do
    # Does password match the one stored in the database?
    case Comeonin.Argon2.checkpw(password, user.encrypted_password) do
      true ->
        {:ok}
      _ ->
        # No, return an error
        {:error, :unauthorized}
    end
  end
end
