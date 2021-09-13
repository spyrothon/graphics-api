defmodule GraphicsAPIWeb.UsersController do
  use GraphicsAPIWeb.APIController

  alias GraphicsAPI.Users

  get "" do
    json(conn, conn.assigns)
  end

  get "/:id" do
    user_id = Map.get(conn.path_params, "id")

    cond do
      user_id != nil -> json(conn, Users.get_user(user_id))
      true -> not_found(conn)
    end
  end

  post "/" do
    user_params = conn.body_params

    with {:ok, user} <- Users.create_user(user_params) do
      json(conn, user)
    else
      {:error, changeset} ->
        conn
        |> changeset_error(changeset)
    end
  end

  put "/:id" do
    user_id = conn.path_params["id"]
    user_params = conn.body_params

    with user = %Users.User{} <- Users.get_user(user_id),
         {:ok, user} <- Users.update_user(user, user_params) do
      json(conn, user)
    else
      user when is_nil(user) ->
        conn |> send_resp(404, "")

      {:error, changeset} ->
        conn
        |> changeset_error(changeset)
    end
  end

  delete "/:id" do
    user_id = conn.path_params["id"]

    with user = %Users.User{} <- Users.get_user(user_id),
         {:ok, _user} <- Users.delete_user(user) do
      no_content(conn)
    else
      nil ->
        conn |> not_found()

      {:error, changeset} ->
        conn
        |> changeset_error(changeset)
    end
  end
end
