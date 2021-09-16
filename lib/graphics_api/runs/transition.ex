defmodule GraphicsAPI.Runs.Transition do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [
    :id,
    :obs_transition_in_name,
    :obs_scene_name,
    :obs_media_source_name,
    :transition_duration,
    :scene_duration,
    :state
  ]

  embedded_schema do
    field(:name, :string)
    field(:obs_transition_in_name, :string)
    field(:obs_scene_name, :string)
    field(:obs_media_source_name, :string)
    field(:transition_duration, :integer)
    field(:scene_duration, :integer)

    field(:state, Ecto.Enum,
      values: GraphicsAPI.Runs.TransitionState.states(),
      default: GraphicsAPI.Runs.TransitionState.pending()
    )
  end

  def changeset(participant, params \\ %{}) do
    participant
    |> cast(params, @fields)
    |> validate_required([:obs_transition_in_name, :obs_scene_name])
  end

  def fields, do: @fields
end

defimpl Jason.Encoder, for: [GraphicsAPI.Runs.Transition] do
  def encode(%{__struct__: _} = struct, options) do
    struct
    |> Map.from_struct()
    |> Map.take(GraphicsAPI.Runs.Transition.fields())
    |> Jason.Encode.map(options)
  end
end
