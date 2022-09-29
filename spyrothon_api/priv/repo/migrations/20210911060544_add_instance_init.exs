defmodule GraphicsAPI.Repo.Migrations.AddInstanceInit do
  use Ecto.Migration

  def change do
    create table(:users_init) do
      add(:schedule_id, references(:runs_schedules))
      timestamps()
    end
  end
end
