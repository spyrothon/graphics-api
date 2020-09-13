use Mix.Config

config :graphics_api, GraphicsAPI.Endpoint, port: 4000

import_config "#{Mix.env()}.exs"
