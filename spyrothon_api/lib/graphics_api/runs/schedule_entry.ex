defmodule GraphicsAPI.Runs.ScheduleEntry do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [
    :id,
    :schedule_id,
    :position,
    :setup_seconds,
    :actual_setup_seconds,
    :entered_at,
    :exited_at,
    :duration_seconds,
    :obs_scene_name,
    :run_id,
    :interview_id
  ]

  @updatable_fields [
    :schedule_id,
    :setup_seconds,
    :actual_setup_seconds,
    :entered_at,
    :exited_at,
    :duration_seconds,
    :obs_scene_name,
    :run_id,
    :interview_id
  ]

  @embeds [
    :enter_transition_set,
    :exit_transition_set
  ]

  schema "runs_schedule_entries" do
    belongs_to(:schedule, GraphicsAPI.Runs.Schedule)
    field(:setup_seconds, :integer)
    field(:actual_setup_seconds, :integer)
    field(:position, :integer)
    field(:entered_at, :utc_datetime)
    field(:exited_at, :utc_datetime)
    field(:duration_seconds, :integer)
    field(:obs_scene_name, :string)

    belongs_to(:run, GraphicsAPI.Runs.Run)
    belongs_to(:interview, GraphicsAPI.Runs.Interview)

    belongs_to(:enter_transition_set, GraphicsAPI.Runs.TransitionSet)
    belongs_to(:exit_transition_set, GraphicsAPI.Runs.TransitionSet)
  end

  def changeset(entry, params \\ %{}) do
    entry
    |> cast(params, @fields)
    |> cast_assoc(:enter_transition_set)
    |> cast_assoc(:exit_transition_set)
    |> _update_duration()
  end

  def update_changeset(entry, params \\ %{}) do
    entry
    |> cast(params, @updatable_fields)
    |> cast_assoc(:enter_transition_set)
    |> cast_assoc(:exit_transition_set)
    |> _update_duration()
  end

  defp _update_duration(changeset) do
    entered_at = get_field(changeset, :entered_at)
    exited_at = get_field(changeset, :exited_at)
    did_change = get_change(changeset, :entered_at) || get_change(changeset, :exited_at)

    cond do
      did_change == false ->
        changeset

      entered_at != nil && exited_at != nil ->
        changeset
        |> put_change(:duration_seconds, DateTime.diff(exited_at, entered_at))

      true ->
        changeset
        |> put_change(:duration_seconds, nil)
    end
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
