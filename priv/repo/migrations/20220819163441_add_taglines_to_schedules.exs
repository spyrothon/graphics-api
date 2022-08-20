defmodule GraphicsAPI.Repo.Migrations.AddTaglinesToSchedules do
  use Ecto.Migration

  def change do
    alter table(:runs_schedules) do
      add(:break_left_title, :string)
      add(:break_left_subtitle, :string)
      add(:break_right_title, :string)
      add(:break_right_subtitle, :string)
      add(:outro_title, :string)
      add(:outro_subtitle, :string)
    end
  end
end
