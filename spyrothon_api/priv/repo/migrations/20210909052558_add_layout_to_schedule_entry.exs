defmodule GraphicsAPI.Repo.Migrations.AddLayoutToScheduleEntry do
  use Ecto.Migration

  def change do
    alter table(:runs_schedule_entries) do
      add(:obs_scene_name, :string)
    end
  end
end
