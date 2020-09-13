defmodule GraphicsAPI.Runs.Run do
  use Ecto.Schema

  schema "runs_runs" do
    field(:game_name, :string)
    field(:category_name, :string)
    field(:platform, :string)
    field(:release_year, :string)
    field(:notes, :string)

    field(:estimate_seconds, :integer, default: 0)
    field(:actual_seconds, :integer)
    field(:finished, :boolean)

    timestamps()
  end
end
