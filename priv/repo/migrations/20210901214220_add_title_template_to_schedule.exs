defmodule GraphicsAPI.Repo.Migrations.AddTitleTemplateToSchedule do
  use Ecto.Migration

  def change do
    alter table(:runs_schedules) do
      add(:run_title_template, :string)
      add(:interview_title_template, :string)
      add(:break_title_template, :string)
    end
  end
end
