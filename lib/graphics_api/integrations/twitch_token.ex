defmodule GraphicsAPI.Integrations.TwitchToken do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [
    :access_token,
    :refresh_token,
    :expires_at
  ]

  @optional_fields []

  @fields [:id, :inserted_at, :updated_at] ++ @required_fields ++ @optional_fields

  schema "integrations_twitch" do
    field(:access_token, :string)
    field(:refresh_token, :string)
    field(:expires_at, :utc_datetime)

    timestamps()
  end

  def changeset(twitch, params \\ %{}) do
    twitch
    |> cast(params, @fields)
    |> validate_required(@required_fields)
  end

  def fields, do: @fields

  # NOTE: Explicitly not serializable
end
