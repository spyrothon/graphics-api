use Mix.Config

config :cors_plug,
  origin: ["*"],
  headers: ["*"]

# Repo and Twitch configuration are managed in `runtime.exs`.
