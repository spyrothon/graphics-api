defmodule GraphicsAPI.Runs do
  import Ecto.Query, warn: false
  alias GraphicsAPI.Repo

  alias GraphicsAPI.Runs.{Schedule, ScheduleEntry, Run}

  ###
  # Runs
  ###

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

  def delete_run(run = %Run{}) do
    run
    |> Repo.delete()
  end

  ###
  # Schedules
  ###

  @schedules_query from(s in Schedule,
                     preload: [
                       :runs,
                       schedule_entries: ^from(e in ScheduleEntry, order_by: [asc: e.position])
                     ]
                   )

  def list_schedules() do
    @schedules_query
    |> Repo.all()
  end

  def get_schedule(schedule_id) do
    @schedules_query
    |> Repo.get(schedule_id)
  end

  def create_schedule(params) do
    %Schedule{}
    |> Schedule.changeset(params)
    |> Repo.insert()
  end

  def update_schedule(schedule = %Schedule{}, params) do
    schedule
    |> Schedule.changeset(params)
    |> Repo.update()
  end

  def delete_schedule(schedule = %Schedule{}) do
    schedule
    |> Repo.delete()
  end
end
