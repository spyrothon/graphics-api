defmodule GraphicsAPI.Runs.ScheduleEntry do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [
    :id,
    :schedule_id,
    :setup_seconds,
    :position,
    :obs_scene_name,
    :run_id,
    :interview_id
  ]

  @updatable_fields [
    :schedule_id,
    :setup_seconds,
    :obs_scene_name,
    :run_id,
    :interview_id
  ]

  @embeds [
    :enter_transitions,
    :exit_transitions
  ]

  schema "runs_schedule_entries" do
    belongs_to(:schedule, GraphicsAPI.Runs.Schedule)
    field(:setup_seconds, :integer)
    field(:position, :integer)
    field(:obs_scene_name, :string)

    belongs_to(:run, GraphicsAPI.Runs.Run)
    belongs_to(:interview, GraphicsAPI.Runs.Interview)

    embeds_many(:enter_transitions, GraphicsAPI.Runs.Transition, on_replace: :delete)
    embeds_many(:exit_transitions, GraphicsAPI.Runs.Transition, on_replace: :delete)
  end

  def changeset(entry, params \\ %{}) do
    entry
    |> cast(params, @fields)
    |> cast_embed(:enter_transitions)
    |> cast_embed(:exit_transitions)
  end

  def update_changeset(entry, params \\ %{}) do
    entry
    |> cast(params, @updatable_fields)
  end

  def fields, do: @fields ++ @embeds
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
