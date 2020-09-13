defmodule GraphicsAPIWeb.RunsController do
  use GraphicsAPIWeb.APIController

  get "" do
    require Logger
    Logger.info("we matched")
    json(conn, GraphicsAPI.Runs.list_runs())
  end
end
