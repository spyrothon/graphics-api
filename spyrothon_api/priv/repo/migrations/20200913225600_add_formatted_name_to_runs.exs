defmodule GraphicsAPI.Repo.Migrations.AddFormattedNameToRuns do
  use Ecto.Migration

  def change do
    alter table(:runs_runs) do
      add(:game_name_formatted, :string)
    end
  end
end
