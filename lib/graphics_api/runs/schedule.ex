defmodule GraphicsAPI.Runs.Schedule do
  use Ecto.Schema
  import Ecto.Changeset

  alias GraphicsAPI.Runs.{Run, ScheduleEntry, Interview}

  @fields [
    :id,
    # Event-like information
    :name,
    :series,
    :start_time,
    :end_time,
    :logo_url,
    :twitch_url,

    # Integration Information
    :run_title_template,
    :interview_title_template,
    :break_title_template,
    :rtmp_host,

    # Live controls
    :current_entry_id,
    :debug,

    # Tagline configuration
    :break_left_title,
    :break_left_subtitle,
    :break_right_title,
    :break_right_subtitle,
    :outro_title,
    :outro_subtitle
  ]

  @required_fields [
    :name,
    :series,
    :start_time
  ]

  # NOTE: Not serialized
  # :obs_websocket_host

  schema "runs_schedules" do
    has_many(:schedule_entries, ScheduleEntry)
    many_to_many(:runs, Run, join_through: ScheduleEntry)
    many_to_many(:interviews, Interview, join_through: ScheduleEntry)

    field(:name, :string)
    field(:series, :string)
    field(:start_time, :utc_datetime)
    field(:end_time, :utc_datetime)
    field(:logo_url, :string)
    field(:twitch_url, :string)

    field(:run_title_template, :string)
    field(:interview_title_template, :string)
    field(:break_title_template, :string)
    field(:rtmp_host, :string)

    field(:current_entry_id, :integer)
    field(:debug, :boolean, default: true)

    field(:break_left_title, :string)
    field(:break_left_subtitle, :string)
    field(:break_right_title, :string)
    field(:break_right_subtitle, :string)
    field(:outro_title, :string)
    field(:outro_subtitle, :string)

    belongs_to(:obs_websocket_host, GraphicsAPI.Integrations.OBSWebsocketConfig,
      on_replace: :update
    )
  end

  def changeset(schedule, params \\ %{}) do
    schedule
    |> cast(params, @fields)
    |> cast_assoc(:schedule_entries)
    |> cast_assoc(:obs_websocket_host)
    |> validate_required(@required_fields)
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
    entry_id =
      case data.current_entry_id do
        nil -> nil
        int -> Integer.to_string(int)
      end

    data
    |> Map.put(:id, Integer.to_string(data.id))
    |> Map.put(:current_entry_id, entry_id)
  end
end
