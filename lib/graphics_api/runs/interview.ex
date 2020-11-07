defmodule GraphicsAPI.Runs.Interview do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [:id, :topic, :notes, :estimate_seconds, :current_question]

  @embeds [
    :interviewees,
    :interviewers,
    :questions
  ]

  schema "runs_interviews" do
    field(:topic, :string)
    field(:notes, :string)
    field(:estimate_seconds, :integer)

    embeds_many(:interviewees, GraphicsAPI.Runs.Participant, on_replace: :delete)
    embeds_many(:interviewers, GraphicsAPI.Runs.Participant, on_replace: :delete)

    embeds_many(:questions, GraphicsAPI.Runs.InterviewQuestion, on_replace: :delete)
    field(:current_question, :string)
  end

  def changeset(interview, params \\ %{}) do
    interview
    |> cast(params, @fields)
    |> cast_participants()
  end

  defp cast_participants(changeset) do
    changeset
    |> cast_embed(:interviewees)
    |> cast_embed(:interviewers)
    |> cast_embed(:questions)
  end

  def fields, do: @fields ++ @embeds
end

defimpl Jason.Encoder, for: [GraphicsAPI.Runs.Interview] do
  def encode(%{__struct__: _} = struct, options) do
    struct
    |> Map.from_struct()
    |> Map.take(GraphicsAPI.Runs.Interview.fields())
    |> stringify_id()
    |> Jason.Encode.map(options)
  end

  defp stringify_id(data) do
    data
    |> Map.put(:id, Integer.to_string(data.id))
  end
end
