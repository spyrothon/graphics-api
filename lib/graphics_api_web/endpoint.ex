defmodule GraphicsAPIWeb.Endpoint do
  require Logger

  use Plug.Router

  if Mix.env() == :dev do
    use Plug.Debugger, otp_app: :graphics_api
  end

  use Plug.ErrorHandler

  plug(Plug.Logger)

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(CORSPlug)
  plug(:dispatch)

  forward("/", to: GraphicsAPIWeb.Router)

  # App Spec

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]}
    }
  end

  def start_link(_opts) do
    with {:ok, config} <- Application.fetch_env(:graphics_api, __MODULE__),
         [port: port] <- config do
      Logger.info("Starting server at http://localhost:#{port}/")
      Plug.Cowboy.http(__MODULE__, [], config)
    else
      _ -> Logger.warn("Could not load port configuration")
    end
  end
end
