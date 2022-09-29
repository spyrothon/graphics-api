defmodule GraphicsAPIWeb.InitController do
  use GraphicsAPIWeb.APIController

  alias GraphicsAPI.Users

  get "/" do
    json(conn, Users.get_init!())
  end

  post "/" do
    init_params = conn.body_params

    with {:ok, init} <- Users.update_init(init_params) do
      json(conn, init)
    else
      {:error, changeset} ->
        conn
        |> changeset_error(changeset)
    end
  end
end
