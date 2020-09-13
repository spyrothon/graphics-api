defmodule GraphicsAPIWeb.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  forward("/api/v1/runs", to: GraphicsAPIWeb.RunsController)

  match(_, do: send_resp(conn, 404, ""))
end
