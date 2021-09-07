defmodule GraphicsAPI.Integrations.TwitchTokenPersister do
  import Ecto.Query, warn: false
  alias GraphicsAPI.Repo
  alias GraphicsAPI.Integrations.{TwitchToken}

  @behaviour Twitch.Persister

  @impl Twitch.Persister
  def save(id, data) do
    %TwitchToken{id: id}
    |> TwitchToken.changeset(data)
    |> Repo.insert!(on_conflict: :replace_all, conflict_target: :id)
  end

  @impl Twitch.Persister
  def load(id) do
    Repo.get(TwitchToken, id) || %TwitchToken{}
  end
end
