defmodule GraphicsAPI.Repo.Migrations.CreateTransitionSets do
  use Ecto.Migration

  def change do
    create table(:runs_transition_sets) do
      add(:state, :string)
      add(:entry_id, references(:runs_schedule_entries))
      add(:transitions, :jsonb)
    end

    alter table(:runs_schedule_entries) do
      remove(:enter_transitions)
      remove(:exit_transitions)
      add(:enter_transition_set_id, references(:runs_transition_sets))
      add(:exit_transition_set_id, references(:runs_transition_sets))
    end
  end
end
