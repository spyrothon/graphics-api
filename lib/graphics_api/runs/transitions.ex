defmodule GraphicsAPI.Runs.Transitions do
  alias GraphicsAPI.Repo
  alias GraphicsAPI.Runs.{TransitionSet, TransitionState}

  def get_transition_set(transition_set_id) do
    Repo.get(TransitionSet, transition_set_id)
  end

  def update_transition_set(transition_set, params) do
    transition_set
    |> TransitionSet.changeset(params)
    |> Repo.update()
  end

  def start_transition(set_id, transition_id) do
    with set = %TransitionSet{} <- get_transition_set(set_id) do
      updated_transitions =
        _do_update_transition(
          set.transitions,
          transition_id,
          &Map.put(&1, :state, TransitionState.in_progress())
        )
        |> Enum.map(&Map.from_struct/1)

      update_transition_set(set, %{transitions: updated_transitions})
    else
      nil -> {:error, :not_found}
      {:error, reason} -> {:error, reason}
    end
  end

  def finish_transition(set_id, transition_id) do
    with set = %TransitionSet{} <- get_transition_set(set_id) do
      updated_transitions =
        _do_update_transition(
          set.transitions,
          transition_id,
          &Map.put(&1, :state, TransitionState.done())
        )
        |> Enum.map(&Map.from_struct/1)

      update_transition_set(set, %{transitions: updated_transitions})
    else
      nil -> {:error, :not_found}
      {:error, reason} -> {:error, reason}
    end
  end

  def reset_transition(set_id, transition_id) do
    with set = %TransitionSet{} <- get_transition_set(set_id) do
      updated_transitions =
        _do_update_transition(
          set.transitions,
          transition_id,
          &Map.put(&1, :state, TransitionState.pending())
        )
        |> Enum.map(&Map.from_struct/1)

      update_transition_set(set, %{transitions: updated_transitions})
    else
      nil -> {:error, :not_found}
      {:error, reason} -> {:error, reason}
    end
  end

  def reset_transition_set(set = %TransitionSet{}) do
    set.transitions
    |> Enum.map(&reset_transition(set.id, &1.id))
    |> Enum.all?(fn
      {:ok, _} -> true
      _ -> false
    end)
  end

  defp _do_update_transition(transitions, transition_id, updater) do
    Enum.map(transitions, fn
      transition = %{id: ^transition_id} -> updater.(transition)
      transition -> transition
    end)
  end
end
