defmodule GraphicsAPI.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {GraphicsAPI.Repo, []},
      {Riverside, [handler: GraphicsAPIWeb.SyncSocketHandler]},
      {Twitch.TokenManager, [id: 1, persister: GraphicsAPI.Integrations.TwitchTokenPersister]},
      GraphicsAPIWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GraphicsAPI.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
