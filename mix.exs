defmodule WebrtcServer.MixProject do
  use Mix.Project

  def project do
    [
      app: :webrtc_server,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :plug_cowboy],
      mod: {WebrtcServer.Application, []}
    ]
  end

  defp deps do
    [
      {:cowboy, "~> 2.10"},
      {:plug, "~> 1.15.1"},
      {:plug_cowboy, "~> 2.0"},
      {:jason, "~> 1.4"}
    ]
  end
end
