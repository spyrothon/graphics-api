defmodule GraphicsAPI.Runs.Participant do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [
    :display_name,
    :twitch_name,
    :twitter_name,
    :actual_seconds,
    :visible
  ]

  embedded_schema do
    field(:display_name, :string)
    field(:twitch_name, :string)
    field(:twitter_name, :string)

    field(:actual_seconds, :integer)

    field(:visible, :boolean, default: true)
  end

  def changeset(participant, params \\ %{}) do
    participant
    |> cast(params, @fields)
    |> validate_required([:display_name])
  end

  def fields, do: @fields
end

defimpl Jason.Encoder, for: [GraphicsAPI.Runs.Participant] do
  def encode(%{__struct__: _} = struct, options) do
    struct
    |> Map.from_struct()
    |> Map.take(GraphicsAPI.Runs.Participant.fields())
    |> Jason.Encode.map(options)
  end
end
