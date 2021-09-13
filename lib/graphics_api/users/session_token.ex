defmodule GraphicsAPI.Users.SessionToken do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [
    :id,
    :user_id,
    :token,
    :expires_at
  ]

  @required_fields @fields -- [:id]

  @derive {Jason.Encoder, only: @required_fields}
  schema "users_session_tokens" do
    belongs_to(:user, GraphicsAPI.Users.User)

    field(:token, :string)
    field(:expires_at, :utc_datetime)
  end

  def changeset(token, params \\ %{}) do
    token
    |> cast(params, @fields)
    |> validate_required(@required_fields)
  end
end
