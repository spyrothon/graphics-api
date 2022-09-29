defmodule GraphicsAPI.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [
    :id,
    :name,
    :password_hash,
    :role,
    :inserted_at,
    :updated_at
  ]

  @cast_fields [
    :name,
    :password,
    :role
  ]

  @required_fields [
    :name,
    :password_hash
  ]

  @visible_fields @fields -- [:password, :password_hash]

  @derive {Jason.Encoder, only: @visible_fields}
  schema "users_users" do
    field(:name, :string)
    field(:password, :string, virtual: true)
    field(:password_hash, :string)
    field(:role, Ecto.Enum, values: GraphicsAPI.Users.Permissions.roles())

    timestamps()
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, @cast_fields)
    |> unique_constraint(:name)
    |> _put_password_hash()
    |> validate_required(@required_fields)
  end

  defp _put_password_hash(
         changeset = %Ecto.Changeset{valid?: true, changes: %{password: password}}
       ) do
    change(changeset, Argon2.add_hash(password))
  end

  defp _put_password_hash(changeset), do: changeset

  def verify_password(user, password) do
    Argon2.check_pass(user, password)
  end

  def fields, do: @fields
end
