defmodule GraphicsAPI.Repo.Migrations.AddTransitionsToScheduleEntries do
  use Ecto.Migration

  def change do
    alter table(:runs_schedule_entries) do
      add(:enter_transitions, :jsonb, default: "[]")
      add(:exit_transitions, :jsonb, default: "[]")
    end
  end
end
