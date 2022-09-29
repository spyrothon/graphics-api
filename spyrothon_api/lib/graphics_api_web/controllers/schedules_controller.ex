defmodule GraphicsAPIWeb.SchedulesController do
  use GraphicsAPIWeb.APIController

  alias GraphicsAPI.Runs

  get "" do
    json(conn, Runs.list_schedules())
  end

  get "/:id" do
    schedule_id = conn.path_params["id"]

    if schedule_id != nil do
      json(conn, Runs.get_schedule(schedule_id))
    end
  end

  post "/" do
    schedule_params = conn.body_params

    with {:ok, schedule} <- Runs.create_schedule(schedule_params) do
      GraphicsAPIWeb.SyncSocketHandler.update_schedule(schedule)
      json(conn, schedule)
    else
      {:error, changeset} ->
        conn
        |> changeset_error(changeset)
    end
  end

  put "/:id" do
    schedule_id = conn.path_params["id"]
    schedule_params = conn.body_params

    with schedule = %Runs.Schedule{} <- Runs.get_schedule(schedule_id),
         {:ok, schedule} <- Runs.update_schedule(schedule, schedule_params) do
      GraphicsAPIWeb.SyncSocketHandler.update_schedule(schedule)
      json(conn, schedule)
    else
      schedule when is_nil(schedule) ->
        conn |> not_found()

      {:error, changeset} ->
        conn
        |> changeset_error(changeset)
    end
  end

  delete "/:id" do
    schedule_id = conn.path_params["id"]

    with schedule = %Runs.Schedule{} <- Runs.get_schedule(schedule_id),
         {:ok, _schedule} <- Runs.delete_schedule(schedule) do
      no_content(conn)
    else
      nil ->
        conn |> not_found()

      {:error, changeset} ->
        conn
        |> changeset_error(changeset)
    end
  end

  post "/:id/entries" do
    schedule_id = conn.path_params["id"]
    entry_params = conn.body_params

    with schedule = %Runs.Schedule{} <- Runs.get_schedule(schedule_id),
         {:ok, entry} <- Runs.add_schedule_entry(schedule, entry_params) do
      schedule = Runs.get_schedule(schedule_id)
      GraphicsAPIWeb.SyncSocketHandler.update_schedule(schedule)
      json(conn, entry)
    else
      schedule when is_nil(schedule) ->
        conn |> not_found()

      {:error, changeset} ->
        conn
        |> changeset_error(changeset)
    end
  end

  delete "/:schedule_id/entries/:entry_id" do
    schedule_id = conn.path_params["schedule_id"]
    entry_id = conn.path_params["entry_id"]

    with schedule = %Runs.Schedule{} <- Runs.get_schedule(schedule_id),
         {:ok, _changeset} <- Runs.remove_schedule_entry(schedule, entry_id) do
      schedule = Runs.get_schedule(schedule_id)
      GraphicsAPIWeb.SyncSocketHandler.update_schedule(schedule)
      no_content(conn)
    else
      nil ->
        conn |> not_found()

      {:error, changeset} ->
        conn
        |> changeset_error(changeset)
    end
  end

  put "/:schedule_id/entries/:entry_id" do
    schedule_id = conn.path_params["schedule_id"]
    entry_id = conn.path_params["entry_id"]
    entry_params = conn.body_params

    with entry = %Runs.ScheduleEntry{} <- Runs.get_schedule_entry(entry_id),
         {:ok, entry} <- Runs.update_schedule_entry(entry, entry_params) do
      schedule = Runs.get_schedule(schedule_id)
      GraphicsAPIWeb.SyncSocketHandler.update_schedule(schedule)
      json(conn, entry)
    else
      nil ->
        conn |> not_found()

      {:error, changeset} ->
        conn
        |> changeset_error(changeset)
    end
  end

  put "/:schedule_id/transition" do
    schedule_id = conn.path_params["schedule_id"]
    body_params = conn.body_params

    with %{"entry_id" => new_entry_id} <- body_params,
         schedule = %Runs.Schedule{} <- Runs.get_schedule(schedule_id),
         {:ok, schedule} <- Runs.transition_schedule_to_entry(schedule, new_entry_id) do
      GraphicsAPIWeb.SyncSocketHandler.update_schedule(schedule)
      json(conn, schedule)
    else
      nil -> not_found(conn)
      ^body_params -> params_error(conn)
      {:error, changeset} -> changeset_error(conn, changeset)
    end
  end

  get "/:id/obs" do
    schedule_id = conn.path_params["id"]

    with schedule = %Runs.Schedule{} <- Runs.get_schedule(schedule_id, with_config: true) do
      json(conn, schedule.obs_websocket_host)
    end
  end

  post "/:id/obs" do
    schedule_id = conn.path_params["id"]
    obs_params = conn.body_params

    with schedule = %Runs.Schedule{} <- Runs.get_schedule(schedule_id, with_config: true),
         {:ok, schedule} <- Runs.update_schedule(schedule, %{obs_websocket_host: obs_params}) do
      GraphicsAPIWeb.SyncSocketHandler.update_schedule(schedule)
      json(conn, schedule.obs_websocket_host)
    else
      nil -> conn |> not_found()
      {:error, changeset} -> conn |> changeset_error(changeset)
    end
  end

  get "/:id/rtmp-stat" do
    schedule_id = conn.path_params["id"]

    with schedule = %Runs.Schedule{} <- Runs.get_schedule(schedule_id),
         {:ok, response} <- RTMPStat.get_stat(rtmp_host: schedule.rtmp_host) do
      json(conn, response)
    else
      nil -> conn |> not_found()
      {:error, changeset} -> conn |> changeset_error(changeset)
    end
  end
end
