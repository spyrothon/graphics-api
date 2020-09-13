use Mix.Config

config :graphics_api, GraphicsAPIWeb.Endpoint, port: 4000

config :graphics_api, :ecto_repos, [GraphicsAPI.Repo]

import_config "#{Mix.env()}.exs"
