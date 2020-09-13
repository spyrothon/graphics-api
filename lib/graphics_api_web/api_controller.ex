defmodule GraphicsAPIWeb.APIController do
  import Plug.Conn

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      import GraphicsAPIWeb.APIController

      use Plug.Router

      plug(:match)
      plug(:dispatch)
    end
  end

  def json(conn, data) do
    send_resp(conn, conn.status || 200, Jason.encode!(data))
  end
end
