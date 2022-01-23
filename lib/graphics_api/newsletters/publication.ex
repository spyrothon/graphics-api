defmodule GraphicsAPI.Newsletters.Publication do
  use Ecto.Schema
  import Ecto.Changeset

  alias GraphicsAPI.Newsletters.{Article, Newsletter}

  @fields [
    :priority,
    :newsletter_id,
    :article_id
  ]

  schema "newsletters_publications" do
    belongs_to(:newsletter, Newsletter)
    belongs_to(:article, Article)
    field(:priority, :integer)
  end

  def changeset(participant, params \\ %{}) do
    participant
    |> cast(params, @fields)
    |> validate_required(@fields)
  end

  def fields, do: @fields
end

defimpl Jason.Encoder, for: [GraphicsAPI.Newsletters.Publication] do
  def encode(%{__struct__: _} = struct, options) do
    struct
    |> Map.from_struct()
    |> Map.take(GraphicsAPI.Newsletters.Publication.fields())
    |> Jason.Encode.map(options)
  end
end
