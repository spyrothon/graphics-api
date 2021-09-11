defmodule GraphicsAPI.Users.Init do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [
    :schedule_id
  ]

  @optional_fields []

  @fields [:id, :inserted_at, :updated_at] ++ @required_fields ++ @optional_fields

  schema "users_init" do
    field(:schedule_id, :integer)

    timestamps()
  end

  def changeset(run, params \\ %{}) do
    run
    |> cast(params, @fields)
    |> validate_required(@required_fields)
  end

  def fields, do: @fields
end

defimpl Jason.Encoder, for: [GraphicsAPI.Users.Init] do
  def encode(%{__struct__: _} = struct, options) do
    struct
    |> Map.from_struct()
    |> Map.take(GraphicsAPI.Users.Init.fields())
    |> stringify_id()
    |> Jason.Encode.map(options)
  end

  defp stringify_id(data) do
    data
    |> Map.put(:id, Integer.to_string(data.id))
  end
end
