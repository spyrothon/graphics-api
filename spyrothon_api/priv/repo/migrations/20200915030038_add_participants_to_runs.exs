defmodule GraphicsAPI.Repo.Migrations.AddParticipantsToRuns do
  use Ecto.Migration

  def change do
    alter table("runs_runs") do
      add(:runners, :jsonb, default: "[]")
      add(:commentators, :jsonb, default: "[]")
    end
  end
end
