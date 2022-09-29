defmodule GraphicsAPI.Users do
  import Ecto.Query, warn: false
  alias GraphicsAPI.Repo

  alias GraphicsAPI.Users.{Init, SessionToken, User}

  @token_size 32

  ###
  # Init
  ###

  def get_init!() do
    # TODO: Make this dynamic?
    Repo.get!(Init, 1)
  end

  def update_init(params) do
    get_init!()
    |> Init.changeset(params)
    |> Repo.update()
  end

  def create_init(params) do
    %Init{}
    |> Init.changeset(params)
    |> Repo.insert()
  end

  ###
  # Users
  ###

  def list_users() do
    Repo.all(User)
  end

  def get_user(user_id) do
    Repo.get(User, user_id)
  end

  def get_user_by_name(name) do
    Repo.get_by(User, name: name)
  end

  def create_user(params) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert()
  end

  def update_user(user = %User{}, params) do
    user
    |> User.changeset(params)
    |> Repo.update()
  end

  def delete_user(user = %User{}) do
    user
    |> Repo.delete()
  end

  def verify_password(user = %User{}, password) do
    User.verify_password(user, password)
  end

  ###
  # Sessions
  ###

  def create_session(user) do
    %SessionToken{}
    |> SessionToken.changeset(%{
      token: build_session_token(),
      user_id: user.id,
      expires_at: _get_new_token_expiration()
    })
    |> Repo.insert()
  end

  def authenticate(token) do
    case verify_session_token(token) do
      {:ok, session} ->
        Repo.get(User, session.user_id)

      error ->
        error
    end
  end

  def verify_session_token(token) do
    with session = %SessionToken{} <- Repo.get_by(SessionToken, token: token),
         :gt <- DateTime.compare(session.expires_at, DateTime.utc_now()) do
      {:ok, session}
    else
      _ -> {:error, :invalid_token}
    end
  end

  def build_session_token() do
    :crypto.strong_rand_bytes(@token_size)
    |> Base.url_encode64()
  end

  defp _get_new_token_expiration() do
    # Token expirations last ~1 month (60*60*24*30)
    DateTime.utc_now()
    |> DateTime.add(2_600_000, :second)
  end
end
