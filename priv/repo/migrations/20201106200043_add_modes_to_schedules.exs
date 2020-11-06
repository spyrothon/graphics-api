defmodule GraphicsAPI.Repo.Migrations.AddModesToSchedules do
  use Ecto.Migration

  def change do
    alter table(:runs_schedules) do
      add(:debug, :boolean, default: true)
    end
  end
end
