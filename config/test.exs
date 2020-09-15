use Mix.Config

config :graphics_api, GraphicsAPI.Repo,
  database: "spyrothon_graphics_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :cors_plug,
  origin: ["*"]
