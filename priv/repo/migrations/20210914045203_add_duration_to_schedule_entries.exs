defmodule GraphicsAPI.Repo.Migrations.AddDurationToScheduleEntries do
  use Ecto.Migration

  def change do
    alter table(:runs_schedule_entries) do
      add(:entered_at, :utc_datetime)
      add(:exited_at, :utc_datetime)
      add(:duration_seconds, :integer)
      add(:actual_setup_seconds, :integer)
    end
  end
end
