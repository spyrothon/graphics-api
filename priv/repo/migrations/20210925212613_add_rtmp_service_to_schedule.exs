defmodule GraphicsAPI.Repo.Migrations.AddRtmpServiceToSchedule do
  use Ecto.Migration

  def change do
    alter table(:runs_schedules) do
      add(:rtmp_host, :string)
    end
  end
end
