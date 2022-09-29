defmodule GraphicsAPI.Runs.Participant do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [
    :id,
    :display_name,
    :twitch_name,
    :twitter_name,
    :pronouns,
    :has_webcam,
    :visible,

    # Run Fields
    :finished_at,
    :actual_seconds,

    # Interview Fields
    :score,

    # Video ingest
    :gameplay_ingest_url,
    :gameplay_crop_transform,
    :webcam_ingest_url,
    :webcam_crop_transform
  ]

  @timing_fields [
    :finished_at,
    :actual_seconds
  ]

  embedded_schema do
    field(:display_name, :string)
    field(:twitch_name, :string)
    field(:twitter_name, :string)
    field(:pronouns, :string)

    field(:has_webcam, :boolean, default: false)
    field(:visible, :boolean, default: true)

    # Run Fields
    field(:actual_seconds, :integer)
    field(:finished_at, :utc_datetime)

    # Interview Fields
    field(:score, :integer, default: 0)

    # Video Ingest
    field(:gameplay_ingest_url, :string)
    field(:gameplay_crop_transform, :map)
    field(:webcam_ingest_url, :string)
    field(:webcam_crop_transform, :map)
  end

  def changeset(participant, params \\ %{}) do
    participant
    |> cast(params, @fields)
    |> validate_required([:display_name])
  end

  def timing_changeset(participant, params \\ %{}) do
    participant
    |> cast(params, @timing_fields)
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
