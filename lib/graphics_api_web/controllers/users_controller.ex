defmodule GraphicsAPIWeb.UsersController do
  use GraphicsAPIWeb.APIController

  alias GraphicsAPI.Users

  get "" do
    json(conn, Users.list_users())
  end

  get "/:id" do
    user_id = Map.get(conn.path_params, "id")

    if user_id != nil do
      json(conn, Users.get_user(user_id))
    end
  end

  post "/" do
    user_params = conn.body_params

    with {:ok, changeset} <- Users.create_user(user_params),
         %{id: created_id} <- changeset do
      json(conn, Users.get_user(created_id))
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
         {:ok, changeset} <- Users.update_user(user, user_params) do
      json(conn, Users.get_user(changeset.id))
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
         {:ok, _changeset} <- Users.delete_user(user) do
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
