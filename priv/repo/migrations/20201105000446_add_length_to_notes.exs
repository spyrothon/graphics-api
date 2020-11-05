defmodule GraphicsAPI.Repo.Migrations.AddLengthToNotes do
  use Ecto.Migration

  def change do
    alter table(:runs_runs) do
      modify(:notes, :text)
    end

    alter table(:runs_interviews) do
      modify(:notes, :text)
    end
  end
end
