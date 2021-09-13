defmodule GraphicsAPIWeb.AuthController do
  use GraphicsAPIWeb.APIController

  alias GraphicsAPI.Users

  post "/login" do
    body_params = conn.body_params

    with %{"name" => name, "password" => password} <- body_params,
         user = %Users.User{} <- Users.get_user_by_name(name),
         {:ok, _user} <- Users.verify_password(user, password),
         {:ok, token} <- Users.create_session(user) do
      json(conn, token)
    else
      nil -> not_found(conn)
      ^body_params -> params_error(conn)
      {:error, "invalid password"} -> not_authorized(conn)
    end
  end

  post "/logout" do
    no_content(conn)
  end
end
