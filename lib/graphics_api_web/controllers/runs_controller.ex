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
      json(conn, Runs.get_run(created_id))
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
      json(conn, Runs.get_run(created_id))
    else
      run when is_nil(run) ->
        conn |> send_resp(404, "")

      {:error, changeset} ->
        conn
        |> changeset_error(changeset)
    end
  end
end
