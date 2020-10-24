defmodule GraphicsAPI.Runs.ScheduleEntry do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [
    :id,
    :schedule_id,
    :setup_seconds,
    :position,
    :run_id
  ]

  schema "runs_schedule_entries" do
    belongs_to(:schedule, GraphicsAPI.Runs.Schedule)
    field(:setup_seconds, :integer)

    field(:position, :integer)
    belongs_to(:run, GraphicsAPI.Runs.Run)
  end

  def changeset(participant, params \\ %{}) do
    participant
    |> cast(params, @fields)
  end

  def fields, do: @fields
end

defimpl Jason.Encoder, for: [GraphicsAPI.Runs.ScheduleEntry] do
  def encode(%{__struct__: _} = struct, options) do
    struct
    |> Map.from_struct()
    |> Map.take(GraphicsAPI.Runs.ScheduleEntry.fields())
    |> stringify_id()
    |> Jason.Encode.map(options)
  end

  def stringify_id(data) do
    data
    |> Map.replace(:id, Integer.to_string(data.id))
    |> Map.replace(:schedule_id, data.schedule_id && Integer.to_string(data.schedule_id))
    |> Map.replace(:run_id, data.run_id && Integer.to_string(data.run_id))
  end
end
