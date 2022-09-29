defmodule GraphicsAPIWeb.APIController do
  import Plug.Conn

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      import GraphicsAPIWeb.APIController

      use Plug.Router

      plug(:match)
      plug(GraphicsAPIWeb.Authentication)
      plug(:dispatch)
    end
  end

  def json(conn, data) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(conn.status || 200, Jason.encode!(data))
  end

  def changeset_error(conn, changeset = %Ecto.Changeset{}) do
    conn
    |> put_status(422)
    |> json(%{errors: Ecto.Changeset.traverse_errors(changeset, &simplify_ecto_error/1)})
  end

  def params_error(conn) do
    conn
    |> put_status(422)
    |> json(%{error: "Given params did not match expected format"})
  end

  def no_content(conn) do
    conn
    |> send_resp(204, "")
  end

  def not_found(conn) do
    conn
    |> send_resp(404, "")
  end

  def not_authorized(conn) do
    conn
    |> send_resp(401, "")
  end

  defp simplify_ecto_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end
end
