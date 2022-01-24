defmodule GraphicsAPI.Newsletters.Newsletter do
  use Ecto.Schema
  import Ecto.Changeset

  alias GraphicsAPI.Newsletters.{Article, Publication}

  @fields [
    :id,
    :title,
    :introduction,
    :published,
    :published_at,
    :inserted_at,
    :updated_at
  ]

  @embeds [
    :articles,
    :publications
  ]

  schema "newsletters_newsletters" do
    field(:title, :string)
    field(:introduction, :string)
    field(:published, :boolean)
    field(:published_at, :utc_datetime)

    has_many(:publications, Publication, on_replace: :delete)
    many_to_many(:articles, Article, join_through: Publication)

    timestamps()
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, @fields)
    |> cast_assoc(:publications)
  end

  def fields, do: @fields ++ @embeds
end

defimpl Jason.Encoder, for: [GraphicsAPI.Newsletters.Newsletter] do
  def encode(%{__struct__: _} = struct, options) do
    struct
    |> Map.from_struct()
    |> Map.take(GraphicsAPI.Newsletters.Newsletter.fields())
    |> Jason.Encode.map(options)
  end
end
