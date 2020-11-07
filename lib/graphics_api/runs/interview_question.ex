defmodule GraphicsAPI.Runs.InterviewQuestion do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [
    :question,
    :image,
    :hint,
    :category,
    :answer,
    :score,
    :show_question,
    :show_hint,
    :show_answer
  ]

  embedded_schema do
    field(:question, :string)
    field(:image, :string)
    field(:hint, :string)
    field(:category, :string)
    field(:answer, :string)
    field(:score, :integer)

    field(:show_question, :boolean, default: false)
    field(:show_hint, :boolean, default: false)
    field(:show_answer, :boolean, default: false)
  end

  def changeset(participant, params \\ %{}) do
    participant
    |> cast(params, @fields)
    |> validate_required([:question])
  end

  def fields, do: @fields
end

defimpl Jason.Encoder, for: [GraphicsAPI.Runs.InterviewQuestion] do
  def encode(%{__struct__: _} = struct, options) do
    struct
    |> Map.from_struct()
    |> Map.take(GraphicsAPI.Runs.InterviewQuestion.fields())
    |> Jason.Encode.map(options)
  end
end
