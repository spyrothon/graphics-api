defmodule GraphicsAPIWeb.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  # Admin/Graphics
  forward("/api/v1/auth", to: GraphicsAPIWeb.AuthController)
  forward("/api/v1/init", to: GraphicsAPIWeb.InitController)
  forward("/api/v1/users", to: GraphicsAPIWeb.UsersController)
  forward("/api/v1/runs", to: GraphicsAPIWeb.RunsController)
  forward("/api/v1/schedules", to: GraphicsAPIWeb.SchedulesController)
  forward("/api/v1/interviews", to: GraphicsAPIWeb.InterviewsController)
  forward("/api/v1/transition-sets", to: GraphicsAPIWeb.TransitionSetsController)

  forward("/api/v1/newsletters", to: GraphicsAPIWeb.NewslettersController)
  forward("/api/v1/articles", to: GraphicsAPIWeb.ArticlesController)

  match(_, do: send_resp(conn, 404, ""))
end
