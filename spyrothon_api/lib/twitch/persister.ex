defmodule Twitch.Persister do
  @type twitch_token :: %{
          access_token: String.t(),
          refresh_token: String.t(),
          expires_at: DateTime.t()
        }
  @doc """
  Parses a string.
  """
  @callback save(integer(), twitch_token) :: twitch_token

  @doc """
  Lists all supported file extensions.
  """
  @callback load(integer()) :: twitch_token
end
