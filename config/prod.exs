use Mix.Config

config :graphics_api, GraphicsAPI.Repo, url: System.fetch_env!("API_DATABASE_URL")

config :cors_plug,
  origin: ["*"],
  headers: ["*"]

# UPDATE: Replace the access token with your channel's user access token from Twitch.
# ALSO: Be sure to add the client_id to `dev.json`.
config :graphics_api, :twitch,
  broadcaster_id: 55555,
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
