defmodule GraphicsAPIWeb.TransitionSetsController do
  use GraphicsAPIWeb.APIController

  alias GraphicsAPI.Runs

  get "/:id" do
    set_id = conn.path_params["id"]

    case Runs.Transitions.get_transition_set(set_id) do
      nil -> not_found(conn)
      set -> json(conn, set)
    end
  end

  post "/:id/reset" do
    set_id = conn.path_params["id"]

    with set <- Runs.Transitions.get_transition_set(set_id),
         true <- Runs.Transitions.reset_transition_set(set),
         entry when entry != nil <- Runs.get_schedule_entry_for_transition_set(set_id),
         schedule when schedule != nil <- Runs.get_schedule(entry.schedule_id) do
      GraphicsAPIWeb.SyncSocketHandler.update_schedule(schedule)
      json(conn, schedule)
    else
      {:error, changeset} ->
        conn
        |> changeset_error(changeset)
    end
  end
end
