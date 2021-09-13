defmodule GraphicsAPIWeb.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  forward("/api/v1/auth", to: GraphicsAPIWeb.AuthController)
  forward("/api/v1/init", to: GraphicsAPIWeb.InitController)
  forward("/api/v1/users", to: GraphicsAPIWeb.UsersController)
  forward("/api/v1/runs", to: GraphicsAPIWeb.RunsController)
  forward("/api/v1/schedules", to: GraphicsAPIWeb.SchedulesController)
  forward("/api/v1/interviews", to: GraphicsAPIWeb.InterviewsController)

  match(_, do: send_resp(conn, 404, ""))
end
