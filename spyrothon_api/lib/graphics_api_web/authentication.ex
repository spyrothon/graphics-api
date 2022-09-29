defmodule GraphicsAPIWeb.Authentication do
  import Plug.Conn

  @token_header_field "x-session-token"

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_authenticated_user(conn) do
      user = %GraphicsAPI.Users.User{} ->
        conn
        |> assign(:current_user, user)
        |> assign(:current_role, user.role)

      _ ->
        conn
    end
  end

  defp get_authenticated_user(conn) do
    conn
    |> get_req_header(@token_header_field)
    |> case do
      [token] -> GraphicsAPI.Users.authenticate(token)
      _ -> nil
    end
  end
end
