use Mix.Config

config :graphics_api, GraphicsAPIWeb.Endpoint, port: 4000
config :graphics_api, :ecto_repos, [GraphicsAPI.Repo]

config :graphics_api, GraphicsAPIWeb.SyncSocketHandler,
  port: 3000,
  path: "/socket/sync",
  # don't accept connections if server already has this number of connections
  max_connections: 1000,
  codec: GraphicsAPIWeb.SyncSocketCodec,
  # force to disconnect a connection if the duration passed. if :infinity is set, do nothing.
  max_connection_age: :infinity,
  # disconnect if no event comes on a connection during this duration
  idle_timeout: 120_000,
  # TCP SO_REUSEPORT flag
  reuse_port: false,
  show_debug_logs: false

config :tesla, adapter: Tesla.Adapter.Hackney

import_config "#{Mix.env()}.exs"
