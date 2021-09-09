defmodule GraphicsAPI.Runs.Schedule do
  use Ecto.Schema
  import Ecto.Changeset

  alias GraphicsAPI.Runs.{Run, ScheduleEntry, Interview}

  @fields [
    :id,
    :run_title_template,
    :interview_title_template,
    :break_title_template,
    :current_entry_id,
    :debug
  ]

  # Not serialized
  # :obs_websocket_host

  schema "runs_schedules" do
    has_many(:schedule_entries, ScheduleEntry)
    many_to_many(:runs, Run, join_through: ScheduleEntry)
    many_to_many(:interviews, Interview, join_through: ScheduleEntry)
    field(:current_entry_id, :integer)

    field(:run_title_template, :string)
    field(:interview_title_template, :string)
    field(:break_title_template, :string)
    field(:debug, :boolean, default: true)

    belongs_to(:obs_websocket_host, GraphicsAPI.Integrations.OBSWebsocketConfig)
  end

  def changeset(participant, params \\ %{}) do
    participant
    |> cast(params, @fields)
    |> cast_assoc(:schedule_entries)
  end

  def fields, do: @fields ++ [:schedule_entries, :runs, :interviews]
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
    |> Map.put(:current_entry_id, Integer.to_string(data.current_entry_id))
  end
end
