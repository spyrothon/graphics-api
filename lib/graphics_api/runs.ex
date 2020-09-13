defmodule GraphicsAPI.Runs do
  import Ecto.Query, warn: false
  alias GraphicsAPI.Repo

  alias GraphicsAPI.Runs.{Run}

  def list_runs() do
    Repo.all(Run)
  end
end
