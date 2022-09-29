defmodule GraphicsAPI.Users.Permissions do
  @roles [:admin, :host, :runner]

  def roles(), do: @roles

  def can?(%{role: :admin}, :permission), do: true
end
