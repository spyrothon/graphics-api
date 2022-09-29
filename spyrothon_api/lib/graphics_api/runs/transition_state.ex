defmodule GraphicsAPI.Runs.TransitionState do
  @states [
    :pending,
    :in_progress,
    :done
  ]

  def states(), do: @states

  def pending(), do: :pending
  def in_progress(), do: :in_progress
  def done(), do: :done

  def pending?(:pending), do: true
  def pending?(_state), do: false

  def in_progress?(:in_progress), do: true
  def in_progress?(_state), do: false

  def done?(:done), do: true
  def done?(_state), do: false
end
