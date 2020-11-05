defmodule GraphicsAPIWeb.SchedulesController do
  use GraphicsAPIWeb.APIController

  alias GraphicsAPI.Runs

  get "" do
    json(conn, Runs.list_schedules())
  end

  get "/:id" do
    schedule_id = Map.get(conn.path_params, "id")

    if schedule_id != nil do
      json(conn, Runs.get_schedule(schedule_id))
    end
  end

  post "/" do
    schedule_params = conn.body_params

    with {:ok, changeset} <- Runs.create_schedule(schedule_params),
         %{id: created_id} <- changeset do
      schedule = Runs.get_schedule(created_id)
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
         {:ok, changeset} <- Runs.update_schedule(schedule, schedule_params),
         %{id: created_id} <- changeset do
      schedule = Runs.get_schedule(created_id)
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
         {:ok, _changeset} <- Runs.delete_schedule(schedule) do
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
         {:ok, changeset} <- Runs.add_schedule_entry(schedule, entry_params) do
      json(conn, Runs.get_schedule(schedule_id))
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
    entry_id = conn.path_params["entry_id"]
    entry_params = conn.body_params

    with entry = %Runs.ScheduleEntry{} <- Runs.get_schedule_entry(entry_id),
         {:ok, _changeset} <- Runs.update_schedule_entry(entry, entry_params) do
      json(conn, Runs.get_schedule_entry(entry_id))
    else
      nil ->
        conn |> not_found()

      {:error, changeset} ->
        conn
        |> changeset_error(changeset)
    end
  end
end
