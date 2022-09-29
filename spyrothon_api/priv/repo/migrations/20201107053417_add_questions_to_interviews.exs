defmodule GraphicsAPI.Repo.Migrations.AddQuestionsToInterviews do
  use Ecto.Migration

  def change do
    alter table(:runs_interviews) do
      add(:questions, :jsonb, default: "[]")
    end
  end
end
