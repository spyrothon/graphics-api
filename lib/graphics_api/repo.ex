defmodule GraphicsAPI.Repo do
  use Ecto.Repo,
    otp_app: :graphics_api,
    adapter: Ecto.Adapters.Postgres
end
