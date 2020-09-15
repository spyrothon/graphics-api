defmodule GraphicsAPI.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [
    :name
  ]

  @optional_fields [
    :twitch_name,
    :twitter_name,
    :discord_name
  ]

  @fields [:id, :inserted_at, :updated_at] ++ @required_fields ++ @optional_fields

  schema "users_users" do
    field(:name, :string)
    field(:twitch_name, :string)
    field(:twitter_name, :string)
    field(:discord_name, :string)

    timestamps()
  end

  def changeset(run, params \\ %{}) do
    run
    |> cast(params, @fields)
    |> validate_required(@required_fields)
  end

  def fields, do: @fields

  require Protocol
  Protocol.derive(Jason.Encoder, GraphicsAPI.Users.User, only: @fields)
end
