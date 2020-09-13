defmodule GraphicsAPITest do
  use ExUnit.Case
  doctest GraphicsAPI

  test "greets the world" do
    assert GraphicsAPI.hello() == :world
  end
end
