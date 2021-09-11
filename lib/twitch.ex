defmodule Twitch do
  use Tesla
  alias Twitch.{Authentication}

  @broadcaster_id Application.get_env(:graphics_api, Twitch)[:broadcaster_id]
  @client_id Application.get_env(:graphics_api, Twitch)[:client_id]

  def client() do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://api.twitch.tv/helix"},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.BearerAuth, token: Authentication.get_valid_token()},
      {Tesla.Middleware.Headers, [{"Client-Id", @client_id}]}
    ]

    Tesla.client(middleware)
  end

  @spec get_games(name: String.t()) ::
          {:ok, list(%{box_art_url: String.t(), id: String.t(), name: String.t()})}
          | {:error, any()}
  def get_games(name: name) do
    response =
      client()
      |> get("/games", query: [name: name])

    case response do
      {:ok, response} ->
        %{"data" => data} = response.body
        {:ok, data}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec modify_channel_information(%{
          optional(:game_name) => String.t(),
          optional(:title) => String.t()
        }) :: :ok | {:error, String.t()}
  def modify_channel_information(opts) do
    game_id = Map.get(opts, :game_name) |> _get_matching_game_id()
    title = Map.get(opts, :title)

    response =
      client()
      |> patch("/channels", %{game_id: game_id, title: title},
        query: [broadcaster_id: @broadcaster_id]
      )

    case response do
      {:ok, _} ->
        :ok

      {:error, reason} ->
        IO.puts(reason)
        {:error, reason}
    end
  end

  def _get_matching_game_id(game_name) do
    {:ok, games_data} = Twitch.get_games(name: game_name)

    case games_data do
      [game | _rest] -> Map.get(game, "id")
      _ -> nil
    end
  end

  # @spec create_stream_marker(String.t()) :: :ok
  # def create_stream_marker(description) do
  # end
end
