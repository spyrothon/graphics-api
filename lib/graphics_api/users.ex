defmodule GraphicsAPI.Users do
  import Ecto.Query, warn: false
  alias GraphicsAPI.Repo

  alias GraphicsAPI.Users.{User}

  def list_users() do
    Repo.all(User)
  end

  def get_user(user_id) do
    Repo.get(User, user_id)
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
end
