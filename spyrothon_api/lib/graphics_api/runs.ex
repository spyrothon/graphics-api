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
                       schedule_entries:
                         ^from(e in ScheduleEntry,
                           order_by: [asc: e.position],
                           preload: [:enter_transition_set, :exit_transition_set]
                         )
                     ]
                   )

  def list_schedules() do
    @schedules_query
    |> Repo.all()
  end

  def get_schedule(schedule_id, opts \\ []) do
    with_config = Keyword.get(opts, :with_config, false)

    @schedules_query
    |> Repo.get(schedule_id)
    |> Repo.preload(if with_config, do: [:obs_websocket_host], else: [])
  end

  def create_schedule(params) do
    %Schedule{}
    |> Schedule.changeset(params)
    |> Repo.insert()
  end

  def update_schedule(original_schedule = %Schedule{}, params) do
    {:ok, schedule} =
      original_schedule
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
    |> Repo.preload([:enter_transition_set, :exit_transition_set])
  end

  def get_schedule_entry_for_transition_set(set_id) do
    Repo.one(
      from(s in ScheduleEntry,
        where: s.exit_transition_set_id == ^set_id or s.enter_transition_set_id == ^set_id
      )
    )
    |> Repo.preload([:enter_transition_set, :exit_transition_set])
  end

  def update_schedule_entry(entry = %ScheduleEntry{}, entry_params) do
    entry
    |> ScheduleEntry.update_changeset(entry_params)
    |> Repo.update()
  end

  def add_schedule_entry(schedule = %Schedule{}, entry_params) do
    entries = schedule.schedule_entries || []

    next_position =
      case Enum.at(entries, -1) do
        %{position: last_position} -> last_position + 1
        nil -> 0
      end

    updated_entry =
      entry_params
      |> Map.put("position", Map.get(entry_params, :position, next_position))
      |> Map.put("schedule_id", schedule.id)

    {:ok, entry} =
      %ScheduleEntry{}
      |> ScheduleEntry.changeset(updated_entry)
      |> Repo.insert()

    # If the schedule doesn't yet have a current entry, this must be the first
    # one, so set it as the current entry to ensure dashboards and everything work.
    if schedule.current_entry_id == nil do
      transition_schedule_to_entry(schedule, entry.id)
    end

    {:ok, entry}
  end

  def remove_schedule_entry(%Schedule{}, entry_id) do
    ScheduleEntry
    |> Repo.get!(entry_id)
    |> Repo.delete()
  end

  def transition_schedule_to_entry(schedule = %Schedule{}, new_entry_id) do
    old_entry_id = schedule.current_entry_id
    transition_time = DateTime.utc_now()

    {:ok, schedule} = update_schedule(schedule, %{current_entry_id: new_entry_id})

    if old_entry_id != nil do
      {:ok, _entry} =
        get_schedule_entry(old_entry_id)
        |> update_schedule_entry(%{exited_at: transition_time})
    end

    if new_entry_id != nil do
      {:ok, _entry} =
        get_schedule_entry(new_entry_id)
        |> update_schedule_entry(%{entered_at: transition_time, exited_at: nil})
    end

    {:ok, schedule}
  end

  defp _update_twitch_channel_info(schedule = %Schedule{}) do
    Task.async(fn ->
      new_run = get_schedule_entry(schedule.current_entry_id)

      case new_run do
        %{run_id: run_id} when not is_nil(run_id) ->
          run = get_run(run_id)

          Twitch.modify_channel_information(%{
            game_name: run.game_name,
            title: _format_run_title(schedule.run_title_template, run)
          })

        %{interview_id: interview_id} when not is_nil(interview_id) ->
          interview = get_interview(interview_id)

          Twitch.modify_channel_information(%{
            game_name: "Just Chatting",
            title: _format_interview_title(schedule.interview_title_template, interview)
          })

        _ ->
          :ok
      end
    end)
  end

  defp _format_run_title(template, run = %Run{}) do
    runner_names = run.runners |> Enum.map_join(", ", & &1.display_name)

    (template || "")
    |> String.replace("{{gameName}}", run.game_name)
    |> String.replace("{{categoryName}}", run.category_name)
    |> String.replace("{{runners}}", runner_names)
  end

  defp _format_interview_title(template, interview = %Interview{}) do
    interviewee_names = interview.interviewees |> Enum.map_join(", ", & &1.display_name)
    interviewer_names = interview.interviewers |> Enum.map_join(", ", & &1.display_name)

    (template || "")
    |> String.replace("{{interviewees}}", interviewee_names)
    |> String.replace("{{interviewers}}", interviewer_names)
  end
end
