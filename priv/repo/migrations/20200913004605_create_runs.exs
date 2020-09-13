defmodule GraphicsAPI.Repo.Migrations.CreateRuns do
  use Ecto.Migration

  def change do
    create table(:runs_runs) do
      add(:game_name, :string)
      add(:category_name, :string)
      add(:platform, :string)
      add(:release_year, :string)
      add(:notes, :string)

      add(:estimate_seconds, :integer, default: 0)
      add(:actual_seconds, :integer)
      add(:finished, :boolean)

      timestamps()
    end
  end
end
