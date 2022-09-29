defmodule Twitch.Authentication do
  use Tesla
  alias Twitch.{TokenManager}

  @client_id Application.get_env(:graphics_api, Twitch)[:client_id]
  @client_secret Application.get_env(:graphics_api, Twitch)[:client_secret]

  def client() do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://id.twitch.tv/"},
      Tesla.Middleware.FormUrlencoded,
      Tesla.Middleware.JSON
    ]

    Tesla.client(middleware)
  end

  def get_valid_token() do
    full_token = TokenManager.get_full_token()

    case DateTime.compare(DateTime.utc_now(), full_token.expires_at) do
      :lt -> full_token.access_token
      _ -> _get_refreshed_token(full_token.refresh_token).access_token
    end
  end

  def _get_refreshed_token(token) do
    token_response = refresh_token(token)

    new_token = %{
      access_token: token_response["access_token"],
      refresh_token: token_response["refresh_token"],
      expires_at: DateTime.add(DateTime.utc_now(), token_response["expires_in"] - 60)
    }

    TokenManager.update_token(new_token)
    TokenManager.get_full_token()
  end

  def refresh_token(token) do
    {:ok, response} =
      client()
      |> post(
        "/oauth2/token",
        %{
          grant_type: "refresh_token",
          refresh_token: token,
          client_id: @client_id,
          client_secret: @client_secret
        }
      )

    response.body
  end
end
