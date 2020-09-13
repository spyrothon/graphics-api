defmodule GraphicsAPI.MixProject do
  use Mix.Project

  def project do
    [
      app: :graphics_api,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: extra_applications(Mix.env()),
      mod: {GraphicsAPI.Application, []}
    ]
  end

  defp extra_applications(:dev), do: extra_applications(:all) ++ [:exsync]
  defp extra_applications(_all), do: [:logger]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.2"},
      {:plug, "~> 1.6"},
      {:plug_cowboy, "~> 2.0"},
      {:exsync, "~> 0.2", only: :dev}
    ]
  end
end
