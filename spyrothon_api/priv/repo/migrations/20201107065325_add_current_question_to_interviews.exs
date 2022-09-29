defmodule GraphicsAPI.Repo.Migrations.AddCurrentQuestionToInterviews do
  use Ecto.Migration

  def change do
    alter table(:runs_interviews) do
      add(:current_question, :string)
    end
  end
end
