defmodule GraphicsAPI.Repo.Migrations.CreateScheduleEntries do
  use Ecto.Migration

  def change do
    create table(:runs_schedules) do
    end

    create table(:runs_schedule_entries) do
      add(:schedule_id, references(:runs_schedules))
      add(:position, :integer)
      add(:run_id, references(:runs_runs))
      add(:setup_seconds, :integer)
    end
  end
end
