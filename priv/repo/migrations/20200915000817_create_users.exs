defmodule GraphicsAPI.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users_users) do
      add(:name, :string)
      add(:twitch_name, :string)
      add(:twitter_name, :string)
      add(:discord_name, :string)

      timestamps()
    end
  end
end
