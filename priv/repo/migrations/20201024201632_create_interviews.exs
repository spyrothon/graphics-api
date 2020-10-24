defmodule GraphicsAPI.Repo.Migrations.CreateInterviews do
  use Ecto.Migration

  def change do
    create table(:runs_interviews) do
      add(:topic, :string)
      add(:notes, :string)
      add(:estimate_seconds, :integer)
      add(:interviewees, :jsonb, default: "[]")
      add(:interviewers, :jsonb, default: "[]")
    end

    alter table(:runs_schedule_entries) do
      add(:interview_id, references(:runs_interviews))
    end
  end
end
