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
    {:ok, schedule} =
      schedule
      |> Schedule.changeset(params)
      |> Repo.update()

    _update_twitch_channel_info(schedule)

    {:ok, schedule}
  end

  def delete_schedule(schedule = %Schedule{}) do
    schedule
    |> Repo.delete()
  end

  def get_schedule_entry(entry_id) do
    Repo.get(ScheduleEntry, entry_id)
  end

  def update_schedule_entry(entry = %ScheduleEntry{}, entry_params) do
    entry
    |> ScheduleEntry.update_changeset(entry_params)
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

  defp _update_twitch_channel_info(%Schedule{current_entry_id: current_entry_id}) do
    new_run = get_schedule_entry(current_entry_id)

    case new_run.run_id do
      nil ->
        :ok

      run_id ->
        run = get_run(run_id)

        Twitch.modify_channel_information(%{
          game_name: run.game_name,
          title: "Spyrothon 7 is happening September 24th! | #{run.game_name}"
        })
    end
  end
end
