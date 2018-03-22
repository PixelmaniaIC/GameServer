defmodule GameServer.MixProject do
  use Mix.Project

  def project do
    [
      app: :game_server,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {GameServer.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:json, "~> 1.0"},
      {:poison, "~> 3.1"},
      {:egd, github: "erlang/egd"}
    ]
  end
end
