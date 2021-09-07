defmodule GraphicsAPI.Integrations do
  alias GraphicsAPI.Integrations.{TwitchToken}

  def get_twitch_access_token(twitch_id) do
    integration = Repo.get(TwitchToken, twitch_id)
    integration.access_token
  end

  def is_valid(%TwitchToken{expires_at: expires_at}) do
    now = DateTime.utc_now()

    case DateTime.compare(now, expires_at) do
      :lt -> true
      _ -> false
    end
  end

  def refresh_twitch(%TwitchToken{refresh_token: refresh_token}) do
  end
end
