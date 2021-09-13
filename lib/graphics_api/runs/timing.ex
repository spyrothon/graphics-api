defmodule GraphicsAPI.Runs.Timing do
  import Ecto.Query, warn: false
  alias GraphicsAPI.Repo

  alias GraphicsAPI.Runs.{Run}

  # Guards for possible run states
  def is_pending(%{started_at: start, finished: finished})
      when is_nil(start) and finished != true,
      do: true

  def is_pending(_run), do: false

  def is_started(%{started_at: start, finished: finished})
      when not is_nil(start) and finished != true,
      do: true

  def is_started(_run), do: false

  def is_paused(%{paused_at: paused_at}) when not is_nil(paused_at), do: true
  def is_paused(_run), do: false
  def is_finished(%{finished: finished}) when finished == true, do: true
  def is_finished(_run), do: false

  def is_running(run), do: is_started(run) && !is_paused(run) && !is_finished(run)

  def start_run(run = %Run{}, start_time \\ DateTime.utc_now()) do
    cond do
      is_pending(run) ->
        run
        |> Run.timing_changeset(%{
          started_at: start_time,
          finished: false,
          finished_at: nil,
          actual_seconds: nil,
          pause_seconds: nil,
          paused_at: nil
        })
        |> Repo.update()

      true ->
        {:ok, run}
    end
  end

  def finish_run(run = %Run{}, finish_time \\ DateTime.utc_now()) do
    cond do
      is_started(run) and not is_finished(run) ->
        actual_seconds = DateTime.diff(finish_time, run.started_at) - (run.pause_seconds || 0)

        updated_runners =
          run.runners
          |> Enum.map(fn runner ->
            %{
              runner
              | finished_at: Map.get(runner, :finished_at, finish_time),
                actual_seconds: Map.get(runner, :actual_seconds, actual_seconds)
            }
            |> Map.from_struct()
          end)

        run
        |> Run.timing_changeset(%{
          finished_at: finish_time,
          finished: true,
          actual_seconds: actual_seconds,
          runners: updated_runners
        })
        |> Repo.update()

      true ->
        {:ok, run}
    end
  end

  def pause_run(run = %Run{}, pause_time \\ DateTime.utc_now()) do
    cond do
      is_running(run) ->
        run
        |> Run.timing_changeset(%{paused_at: pause_time})
        |> Repo.update()

      true ->
        {:ok, run}
    end
  end

  def resume_run(run = %Run{}, resume_time \\ DateTime.utc_now()) do
    cond do
      is_paused(run) or is_finished(run) ->
        pause_seconds =
          cond do
            is_paused(run) -> DateTime.diff(resume_time, run.paused_at) + (run.pause_seconds || 0)
            true -> run.pause_seconds
          end

        run
        |> Run.timing_changeset(%{
          finished_at: nil,
          finished: false,
          actual_seconds: nil,
          pause_seconds: pause_seconds,
          paused_at: nil
        })
        |> Repo.update()

      true ->
        {:ok, run}
    end
  end

  def reset_run(run = %Run{}) do
    reset_runners =
      run.runners
      |> Enum.map(fn runner ->
        %{runner | finished_at: nil, actual_seconds: nil} |> Map.from_struct()
      end)

    run
    |> Run.timing_changeset(%{
      started_at: nil,
      finished: false,
      finished_at: nil,
      actual_seconds: nil,
      pause_seconds: nil,
      paused_at: nil,
      runners: reset_runners
    })
    |> Repo.update()
  end

  def finish_participant(run = %Run{}, participant_id, finish_time \\ DateTime.utc_now()) do
    actual_seconds = DateTime.diff(finish_time, run.started_at) - (run.pause_seconds || 0)

    updated_runners =
      run.runners
      |> _update_participant(
        participant_id,
        fn runner -> %{runner | finished_at: finish_time, actual_seconds: actual_seconds} end
      )

    all_finished = updated_runners |> Enum.all?(&(&1.finished_at != nil))

    changes =
      cond do
        all_finished ->
          %{
            runners: updated_runners,
            finished: true,
            finished_at: finish_time,
            actual_seconds: actual_seconds
          }

        true ->
          %{runners: updated_runners}
      end

    run
    |> Run.timing_changeset(changes)
    |> Repo.update()
  end

  def resume_participant(run = %Run{}, participant_id) do
    updated_runners =
      run.runners
      |> _update_participant(
        participant_id,
        fn runner -> %{runner | finished_at: nil, actual_seconds: nil} end
      )

    run
    |> Run.timing_changeset(%{
      finished: false,
      finished_at: nil,
      actual_seconds: nil,
      runners: updated_runners
    })
    |> Repo.update()
  end

  defp _update_participant(participants, target_id, func) do
    participants
    |> Enum.map(fn runner ->
      case runner do
        %{id: ^target_id} -> func.(runner)
        _ -> runner
      end
      |> Map.from_struct()
    end)
  end
end
