defmodule GraphicsAPI.Repo.Migrations.AddSessionTokens do
  use Ecto.Migration

  def change do
    create table(:users_session_tokens) do
      add(:user_id, references(:users_users))
      add(:token, :string)
      add(:expires_at, :utc_datetime)
    end
  end
end
