defmodule GraphicsAPI.Runs do
  import Ecto.Query, warn: false
  alias GraphicsAPI.Repo

  alias GraphicsAPI.Runs.{Run}

  def list_runs() do
    Repo.all(Run)
  end

  def get_run(run_id) do
    Repo.get(Run, run_id)
  end

  def create_run(params) do
    %Run{}
    |> Run.changeset(params)
    |> Repo.insert()
  end

  def update_run(run = %Run{}, params) do
    run
    |> Run.changeset(params)
    |> Repo.update()
  end
end
