defmodule Twitch.TokenManager do
  @moduledoc """
    TokenManager is a GenServer that provides user access tokens for calling
    the Twitch API. Since Twitch's access tokens expire frequently, this
    process stores both an access token and a refresh token, so that new
    access tokens can be created while the application is still running. New
    tokens are then persisted through a `Twitch.Persister` to be usable across
    application restarts. This avoids users having to update config.exs or
    other one-time configurations and restart the application frequently.
  """

  use GenServer

  @type state :: %{
          persister: Twitch.Persister,
          id: integer(),
          access_token: String.t(),
          refresh_token: String.t(),
          expires_at: DateTime.t()
        }

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def get_token() do
    GenServer.call(__MODULE__, :get_token)
  end

  def get_full_token() do
    GenServer.call(__MODULE__, :get_full_token)
  end

  def update_token(new_token_data) do
    GenServer.cast(__MODULE__, {:update_token, new_token_data})
  end

  @impl true
  def init(id: id, persister: persister) do
    token = persister.load(id)

    {:ok,
     %{
       persister: persister,
       id: id,
       access_token: token.access_token,
       refresh_token: token.refresh_token,
       expires_at: token.expires_at
     }}
  end

  @impl true
  def handle_call(:get_token, _from, state) do
    token = state.access_token
    {:reply, token, state}
  end

  @impl true
  def handle_call(:get_full_token, _from, state) do
    full_token = Map.take(state, [:access_token, :refresh_token, :expires_at])
    {:reply, full_token, state}
  end

  @impl true
  def handle_cast({:update_token, new_token_data}, state) do
    %{persister: persister, id: id} = state

    %{access_token: access_token, refresh_token: refresh_token, expires_at: expires_at} =
      new_token_data

    persister.save(id, %{
      access_token: access_token,
      refresh_token: refresh_token,
      expires_at: expires_at
    })

    {:noreply,
     %{state | access_token: access_token, refresh_token: refresh_token, expires_at: expires_at}}
  end
end
