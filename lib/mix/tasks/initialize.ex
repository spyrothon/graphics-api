defmodule Mix.Tasks.Graphics.Initialize do
  @moduledoc "The hello mix task: `mix help hello`"
  use Mix.Task

  alias GraphicsAPI.{Runs, Users}

  @shortdoc "Creates a database and initializes necessary info to run the Graphics API"
  def run(_) do
    Mix.Shell.IO.info("Installing dependencies")
    Mix.Task.run("deps.get")
    Mix.Shell.IO.info("\n\nCreating the database")
    Mix.Task.run("ecto.create")
    Mix.Shell.IO.info("\n\nRunning database migrations")
    Mix.Task.run("ecto.migrate")

    Mix.Shell.IO.info("\n\nStarting application to run necessary db commands")
    Mix.Task.run("app.start")

    Mix.Shell.IO.info("\n\nCreating initial data (schedule, init record, etc)")
    create_init()

    Mix.Shell.IO.info("\n\nInitial data has been set up. You can now run `mix run --no-halt` to start using the Graphics API")
  end

  def create_init() do
    {:ok, schedule} = Runs.create_schedule(%{name: "First Schedule", series: "Mainline", start_time: DateTime.utc_now()})
    Users.create_init(%{schedule_id: schedule.id})
  end
end
