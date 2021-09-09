defmodule GraphicsAPI.Repo.Migrations.CreateOBSWebsocketConfigs do
  use Ecto.Migration

  def change do
    create table(:integrations_obs_websocket) do
      add(:name, :string)
      add(:host, :string)
      add(:port, :integer)
      add(:password, :string)
    end

    alter table(:runs_schedules) do
      add(
        :obs_websocket_host_id,
        references(:integrations_obs_websocket, on_replace: :nilify_all)
      )
    end
  end
end
