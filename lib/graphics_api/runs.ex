defmodule GraphicsAPI.Runs do
  import Ecto.Query, warn: false
  alias GraphicsAPI.Repo

  alias GraphicsAPI.Runs.{Interview, Schedule, ScheduleEntry, Run}

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
  # Interviews
  ###

  def list_interviews() do
    Repo.all(Interview)
  end

  def get_interview(interview_id) do
    Repo.get(Interview, interview_id)
  end

  def create_interview(params) do
    %Interview{}
    |> Interview.changeset(params)
    |> Repo.insert()
  end

  def update_interview(interview = %Interview{}, params) do
    interview
    |> Interview.changeset(params)
    |> Repo.update()
  end

  def delete_interview(interview = %Interview{}) do
    interview
    |> Repo.delete()
  end

  ###
  # Schedules
  ###

  @schedules_query from(s in Schedule,
                     preload: [
                       :runs,
                       :interviews,
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

  def add_schedule_entry(schedule = %Schedule{}, entry_params) do
    entries = schedule.schedule_entries
    %{position: last_position} = List.last(entries)

    updated_entry =
      entry_params
      |> Map.put("position", Map.get(entry_params, :position, last_position + 1))
      |> Map.put("schedule_id", schedule.id)

    %ScheduleEntry{}
    |> ScheduleEntry.changeset(updated_entry)
    |> Repo.insert()
  end

  def remove_schedule_entry(schedule = %Schedule{}, entry_id) do
    ScheduleEntry
    |> Repo.get!(entry_id)
    |> Repo.delete()
  end

  def delete_schedule(schedule = %Schedule{}) do
    schedule
    |> Repo.delete()
  end
end
