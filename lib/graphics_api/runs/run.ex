defmodule GraphicsAPI.Runs.Run do
  use Ecto.Schema
  import Ecto.Changeset

  @optional_fields [
    :game_name,
    :game_name_formatted,
    :category_name,
    :estimate_seconds,
    :platform,
    :release_year,
    :notes,
    :actual_seconds,
    :finished,
    :started_at,
    :finished_at,
    :paused_at,
    :pause_seconds
  ]

  @fields [:id, :inserted_at, :updated_at] ++ @optional_fields

  @timing_fields [
    :actual_seconds,
    :started_at,
    :finished,
    :finished_at,
    :paused_at,
    :pause_seconds
  ]

  @embeds [
    :runners,
    :commentators,
    :schedule_entry
  ]

  schema "runs_runs" do
    field(:game_name, :string)
    field(:game_name_formatted, :string)
    field(:category_name, :string)
    field(:platform, :string)
    field(:release_year, :string)
    field(:notes, :string)

    field(:estimate_seconds, :integer)
    field(:actual_seconds, :integer)
    field(:finished, :boolean)
    field(:started_at, :utc_datetime)
    field(:finished_at, :utc_datetime)
    field(:paused_at, :utc_datetime)
    field(:pause_seconds, :integer)

    embeds_many(:runners, GraphicsAPI.Runs.Participant, on_replace: :delete)
    embeds_many(:commentators, GraphicsAPI.Runs.Participant, on_replace: :delete)

    timestamps()
  end

  def changeset(run, params \\ %{}) do
    run
    |> cast(params, @fields)
    |> cast_participants()
  end

  def timing_changeset(run, params \\ %{}) do
    run
    |> cast(params, @timing_fields)
    |> cast_embed(:runners, with: &GraphicsAPI.Runs.Participant.timing_changeset/2)
  end

  defp cast_participants(changeset) do
    changeset
    |> cast_embed(:runners)
    |> cast_embed(:commentators)
  end

  def fields, do: @fields ++ @embeds
end

defimpl Jason.Encoder, for: [GraphicsAPI.Runs.Run] do
  def encode(%{__struct__: _} = struct, options) do
    struct
    |> Map.from_struct()
    |> Map.take(GraphicsAPI.Runs.Run.fields())
    |> stringify_id()
    |> set_formatted_names()
    |> Jason.Encode.map(options)
  end

  defp stringify_id(data) do
    data
    |> Map.put(:id, Integer.to_string(data.id))
  end

  defp set_formatted_names(data) do
    data
    |> Map.put(:game_name_formatted, data.game_name_formatted || data.game_name)
  end
end
