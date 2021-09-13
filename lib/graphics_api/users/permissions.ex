defmodule GraphicsAPI.Users.Permissions do
  @roles [:admin, :host, :runner]

  def roles(), do: @roles
end
