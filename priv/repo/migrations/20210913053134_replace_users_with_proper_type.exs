defmodule GraphicsAPI.Repo.Migrations.ReplaceUsersWithProperType do
  use Ecto.Migration

  def change do
    drop(table(:users_users))

    create table(:users_users) do
      add(:name, :string)
      add(:password_hash, :string)
      add(:role, :string)

      timestamps()
    end
  end
end
