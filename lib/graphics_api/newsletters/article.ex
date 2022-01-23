defmodule GraphicsAPI.Newsletters.Article do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [
    :id,
    :title,
    :author_name,
    :published_at,
    :content,
    :inserted_at,
    :updated_at
  ]

  schema "newsletters_articles" do
    field(:title, :string)
    field(:author_name, :string)
    field(:published_at, :utc_datetime)
    field(:content, :string)

    timestamps()
  end

  def changeset(participant, params \\ %{}) do
    participant
    |> cast(params, @fields)
    |> validate_required([:title, :content])
  end

  def fields, do: @fields
end

defimpl Jason.Encoder, for: [GraphicsAPI.Newsletters.Article] do
  def encode(%{__struct__: _} = struct, options) do
    struct
    |> Map.from_struct()
    |> Map.take(GraphicsAPI.Newsletters.Article.fields())
    |> Jason.Encode.map(options)
  end
end
