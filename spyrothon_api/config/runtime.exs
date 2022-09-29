import Config

# These rely on the target server having these environment variables

config :graphics_api, GraphicsAPI.Repo, url: System.fetch_env!("API_DATABASE_URL")

config :graphics_api, GraphicsAPIWeb.Endpoint,
  port: System.fetch_env!("PORT") |> String.to_integer()

config :graphics_api, :twitch,
  broadcaster_id: System.fetch_env!("TWITCH_BROADCASTER_ID"),
  client_id: System.fetch_env!("TWITCH_CLIENT_ID"),
  client_secret: System.fetch_env!("TWITCH_CLIENT_SECRET"),
  scopes: [
    # Get info about bits on the channel
    "bits:read",
    # Manage stream title, create markers, etc.
    "channel:manage:broadcast",
    # Manage polls
    "channel:manage:polls",
    # Manage predictions
    "channel:manage:predictions"
  ]
