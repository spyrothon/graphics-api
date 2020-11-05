defmodule GraphicsAPIWeb.SyncSocketHandler do
  # set 'otp_app' param like Ecto.Repo
  use Riverside, otp_app: :graphics_api

  @impl Riverside
  def init(session, state) do
    join_channel("sync_updates")
    # initialization
    {:ok, session, state}
  end

  @impl Riverside
  def handle_message(msg, session, state) do
    deliver_channel("sync_updates", msg)

    {:ok, session, state}
  end

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
