defmodule GraphicsAPIWeb.SyncSocketHandler do
  # set 'otp_app' param like Ecto.Repo
  use Riverside, otp_app: :graphics_api

  alias GraphicsAPI.Runs

  @impl Riverside
  def init(session, state) do
    join_channel("sync_updates")
    {:ok, session, state}
  end

  @impl Riverside
  def handle_message(
        %{
          "type" => "obs_transition_started",
          "set_id" => set_id,
          "transition_id" => transition_id
        },
        session,
        state
      ) do
    with {:ok, set} <- Runs.Transitions.start_transition(set_id, transition_id),
         entry when entry != nil <- Runs.get_schedule_entry_for_transition_set(set_id),
         schedule when schedule != nil <- Runs.get_schedule(entry.schedule_id) do
      update_schedule(schedule)
    else
      nil -> nil
    end

    {:ok, session, state}
  end

  @impl Riverside
  def handle_message(
        %{
          "type" => "obs_transition_finished",
          "set_id" => set_id,
          "transition_id" => transition_id
        },
        session,
        state
      ) do
    with {:ok, set} <- Runs.Transitions.finish_transition(set_id, transition_id),
         entry when entry != nil <- Runs.get_schedule_entry_for_transition_set(set_id),
         schedule when schedule != nil <- Runs.get_schedule(entry.schedule_id) do
      update_schedule(schedule)
    else
      nil -> nil
    end

    {:ok, session, state}
  end

  @impl Riverside
  def handle_message(
        %{
          "type" => "obs_transition_reset",
          "set_id" => set_id,
          "transition_id" => transition_id
        },
        session,
        state
      ) do
    with {:ok, set} <- Runs.Transitions.reset_transition(set_id, transition_id),
         entry when entry != nil <- Runs.get_schedule_entry_for_transition_set(set_id),
         schedule when schedule != nil <- Runs.get_schedule(entry.schedule_id) do
      update_schedule(schedule)
    else
      nil -> nil
    end

    {:ok, session, state}
  end

  @impl Riverside
  def handle_message(msg, session, state) do
    deliver_channel("sync_updates", msg)

    {:ok, session, state}
  end

  ###
  # Static API
  ###

  def update_schedule(schedule) do
    _sync(%{type: "load_schedule", schedule: schedule})
  end

  def update_run(run) do
    _sync(%{type: "load_run", run: run})
  end

  def update_interview(interview) do
    _sync(%{type: "load_interview", interview: interview})
  end

  defp _sync(data) do
    deliver_channel("sync_updates", data)
  end
end
