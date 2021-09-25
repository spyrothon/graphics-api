defmodule GraphicsAPI.Runs.TransitionSet do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [
    :id,
    :state
  ]

  @embeds [
    :transitions
  ]

  schema "runs_transition_sets" do
    field(:state, Ecto.Enum, values: GraphicsAPI.Runs.TransitionState.states())

    embeds_many(:transitions, GraphicsAPI.Runs.Transition, on_replace: :delete)
  end

  def changeset(participant, params \\ %{}) do
    participant
    |> cast(params, @fields)
    |> cast_embed(:transitions)
  end

  def fields, do: @fields ++ @embeds
end

defimpl Jason.Encoder, for: [GraphicsAPI.Runs.TransitionSet] do
  def encode(%{__struct__: _} = struct, options) do
    struct
    |> Map.from_struct()
    |> Map.take(GraphicsAPI.Runs.TransitionSet.fields())
    |> stringify_id()
    |> Jason.Encode.map(options)
  end

  defp stringify_id(data) do
    data
    |> Map.put(:id, Integer.to_string(data.id))
  end
end
