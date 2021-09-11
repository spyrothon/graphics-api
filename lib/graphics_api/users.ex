defmodule GraphicsAPI.Users do
  import Ecto.Query, warn: false
  alias GraphicsAPI.Repo

  alias GraphicsAPI.Users.{Init, User}

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
end
