defmodule GraphicsAPI.Repo.Migrations.AddTwitchIntegration do
  use Ecto.Migration

  def change do
    create table(:integrations_twitch) do
      add(:access_token, :string)
      add(:refresh_token, :string)
      add(:expires_at, :utc_datetime)

      timestamps()
    end
  end
end
