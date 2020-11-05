defmodule GraphicsAPIWeb.RunsController do
  use GraphicsAPIWeb.APIController

  alias GraphicsAPI.Runs

  get "" do
    json(conn, Runs.list_runs())
  end

  get "/:id" do
    run_id = Map.get(conn.path_params, "id")

    if run_id != nil do
      json(conn, Runs.get_run(run_id))
    end
  end

  post "/" do
    run_params = conn.body_params

    with {:ok, changeset} <- Runs.create_run(run_params),
         %{id: created_id} <- changeset do
      run = Runs.get_run(created_id)
      GraphicsAPIWeb.SyncSocketHandler.update_run(run)
      json(conn, run)
    else
      {:error, changeset} ->
        conn
        |> changeset_error(changeset)
    end
  end

  put "/:id" do
    run_id = conn.path_params["id"]
    run_params = conn.body_params

    with run = %Runs.Run{} <- Runs.get_run(run_id),
         {:ok, changeset} <- Runs.update_run(run, run_params),
         %{id: created_id} <- changeset do
      run = Runs.get_run(created_id)
      GraphicsAPIWeb.SyncSocketHandler.update_run(run)
      json(conn, run)
    else
      run when is_nil(run) ->
        conn |> not_found()

      {:error, changeset} ->
        conn
        |> changeset_error(changeset)
    end
  end

  delete "/:id" do
    run_id = conn.path_params["id"]

    with run = %Runs.Run{} <- Runs.get_run(run_id),
         {:ok, _changeset} <- Runs.delete_run(run) do
      no_content(conn)
    else
      nil ->
        conn |> not_found()

      {:error, changeset} ->
        conn
        |> changeset_error(changeset)
    end
  end
end
