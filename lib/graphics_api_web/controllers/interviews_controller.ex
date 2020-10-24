defmodule GraphicsAPIWeb.InterviewsController do
  use GraphicsAPIWeb.APIController

  alias GraphicsAPI.Runs

  get "" do
    json(conn, Runs.list_interviews())
  end

  get "/:id" do
    interview_id = Map.get(conn.path_params, "id")

    if interview_id != nil do
      json(conn, Runs.get_interview(interview_id))
    end
  end

  post "/" do
    interview_params = conn.body_params

    with {:ok, changeset} <- Runs.create_interview(interview_params),
         %{id: created_id} <- changeset do
      json(conn, Runs.get_interview(created_id))
    else
      {:error, changeset} ->
        conn
        |> changeset_error(changeset)
    end
  end

  put "/:id" do
    interview_id = conn.path_params["id"]
    interview_params = conn.body_params

    with interview = %Runs.Interview{} <- Runs.get_interview(interview_id),
         {:ok, changeset} <- Runs.update_interview(interview, interview_params),
         %{id: created_id} <- changeset do
      json(conn, Runs.get_interview(created_id))
    else
      interview when is_nil(interview) ->
        conn |> not_found()

      {:error, changeset} ->
        conn
        |> changeset_error(changeset)
    end
  end

  delete "/:id" do
    interview_id = conn.path_params["id"]

    with interview = %Runs.Interview{} <- Runs.get_interview(interview_id),
         {:ok, _changeset} <- Runs.delete_interview(interview) do
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
