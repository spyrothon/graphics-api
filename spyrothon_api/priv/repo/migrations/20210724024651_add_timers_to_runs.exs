defmodule GraphicsAPI.Repo.Migrations.AddTimersToRuns do
  use Ecto.Migration

  def change do
    alter table(:runs_runs) do
      add(:started_at, :utc_datetime)
      add(:finished_at, :utc_datetime)
      add(:paused_at, :utc_datetime)
      add(:pause_seconds, :integer, default: 0)
    end

    # participants are also gaining the `finished_at` property. All timers in a run will be based off of the run's own start and pause times.
  end
end
