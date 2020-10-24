defmodule GraphicsAPI.Runs.Schedule do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [
    :id
  ]

  schema "runs_schedules" do
    has_many(:schedule_entries, GraphicsAPI.Runs.ScheduleEntry)
    many_to_many(:runs, GraphicsAPI.Runs.Run, join_through: GraphicsAPI.Runs.ScheduleEntry)
  end

  def changeset(participant, params \\ %{}) do
    participant
    |> cast(params, @fields)
    |> cast_assoc(:schedule_entries)
  end

  def fields, do: @fields ++ [:schedule_entries, :runs]
end

defimpl Jason.Encoder, for: [GraphicsAPI.Runs.Schedule] do
  def encode(%{__struct__: _} = struct, options) do
    struct
    |> Map.from_struct()
    |> stringify_ids()
    |> Map.take(GraphicsAPI.Runs.Schedule.fields())
    |> Jason.Encode.map(options)
  end

  def stringify_ids(data) do
    data
    |> Map.put(:id, Integer.to_string(data.id))
  end
end
