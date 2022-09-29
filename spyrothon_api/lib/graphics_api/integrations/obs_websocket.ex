defmodule GraphicsAPI.Integrations.OBSWebsocketConfig do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [
    :name,
    :host,
    :port,
    :password
  ]

  schema "integrations_obs_websocket" do
    field(:name, :string)
    field(:host, :string)
    field(:port, :integer)
    field(:password, :string)
  end

  def changeset(config, params \\ %{}) do
    config
    |> cast(params, @fields)
    |> validate_required([:host, :port, :password])
  end

  def fields(), do: [:id] ++ @fields
end

defimpl Jason.Encoder, for: [GraphicsAPI.Integrations.OBSWebsocketConfig] do
  def encode(%{__struct__: _} = struct, options) do
    struct
    |> Map.from_struct()
    |> Map.take(GraphicsAPI.Integrations.OBSWebsocketConfig.fields())
    |> stringify_id()
    |> Jason.Encode.map(options)
  end

  defp stringify_id(data) do
    data
    |> Map.put(:id, Integer.to_string(data.id))
  end
end
