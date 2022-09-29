defmodule GraphicsAPI.Integrations do
  import Ecto.Query, warn: false
  alias GraphicsAPI.Repo

  alias GraphicsAPI.Integrations.{OBSWebsocketConfig}

  def create_obs_config(params) do
    %OBSWebsocketConfig{}
    |> OBSWebsocketConfig.changeset(params)
    |> Repo.insert()
  end

  def update_obs_config(config, params) do
    (config ||
       %OBSWebsocketConfig{})
    |> OBSWebsocketConfig.changeset(params)
    |> Repo.insert(on_conflict: :replace_all, conflict_target: :id)
  end
end
