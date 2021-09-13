defmodule GraphicsAPIWeb.RunsController do
  use GraphicsAPIWeb.APIController

  alias GraphicsAPI.Runs

  defmacro modify_run(conn, run_id, action) do
    quote bind_quoted: [conn: conn, run_id: run_id, action: action] do
      with run = %Runs.Run{} <- Runs.get_run(run_id),
           {:ok, updated_run} <- action.(run) do
        _respond_with_run(conn, updated_run)
      else
        run when is_nil(run) ->
          conn |> not_found()

        {:error, changeset} ->
          conn
          |> changeset_error(changeset)
      end
    end
  end

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

    with {:ok, run} <- Runs.create_run(run_params) do
      _respond_with_run(conn, run)
    else
      {:error, changeset} ->
        conn
        |> changeset_error(changeset)
    end
  end

  put "/:id" do
    run_id = conn.path_params["id"]

    modify_run(
      conn,
      run_id,
      fn run ->
        Runs.update_run(run, conn.body_params)
      end
    )
  end

  delete "/:id" do
    run_id = conn.path_params["id"]
    modify_run(conn, run_id, &Runs.delete_run/1)
    no_content(conn)
  end

  patch "/:id/start" do
    run_id = conn.path_params["id"]
    modify_run(conn, run_id, &Runs.Timing.start_run/1)
  end

  patch "/:id/finish" do
    run_id = conn.path_params["id"]
    modify_run(conn, run_id, &Runs.Timing.finish_run/1)
  end

  patch "/:id/pause" do
    run_id = conn.path_params["id"]
    modify_run(conn, run_id, &Runs.Timing.pause_run/1)
  end

  patch "/:id/resume" do
    run_id = conn.path_params["id"]
    modify_run(conn, run_id, &Runs.Timing.resume_run/1)
  end

  patch "/:id/reset" do
    run_id = conn.path_params["id"]
    modify_run(conn, run_id, &Runs.Timing.reset_run/1)
  end

  patch "/:id/finish-participant/:participant_id" do
    run_id = conn.path_params["id"]

    modify_run(
      conn,
      run_id,
      fn run ->
        Runs.Timing.finish_participant(run, conn.path_params["participant_id"])
      end
    )
  end

  patch "/:id/resume-participant/:participant_id" do
    run_id = conn.path_params["id"]

    modify_run(
      conn,
      run_id,
      fn run ->
        Runs.Timing.resume_participant(run, conn.path_params["participant_id"])
      end
    )
  end

  def _respond_with_run(conn, run) do
    GraphicsAPIWeb.SyncSocketHandler.update_run(run)
    json(conn, run)
  end
end
