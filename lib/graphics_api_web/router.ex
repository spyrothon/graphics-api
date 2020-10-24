defmodule GraphicsAPIWeb.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  forward("/api/v1/users", to: GraphicsAPIWeb.UsersController)
  forward("/api/v1/runs", to: GraphicsAPIWeb.RunsController)
  forward("/api/v1/schedules", to: GraphicsAPIWeb.SchedulesController)

  match(_, do: send_resp(conn, 404, ""))
end
