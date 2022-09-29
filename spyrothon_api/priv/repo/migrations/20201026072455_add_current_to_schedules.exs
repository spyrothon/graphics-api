defmodule GraphicsAPI.Repo.Migrations.AddCurrentToSchedules do
  use Ecto.Migration

  def change do
    alter table(:runs_schedules) do
      add(:current_entry_id, references(:runs_schedule_entries, on_replace: :nilify_all))
    end
  end
end
