defmodule GraphicsAPI.Repo.Migrations.AddEventInfoToSchedules do
  use Ecto.Migration

  def change do
    alter table(:runs_schedules) do
      add(:name, :string)
      add(:series, :string)
      add(:start_time, :utc_datetime)
      add(:end_time, :utc_datetime)
      add(:logo_url, :string)
      add(:twitch_url, :string)
    end
  end
end
