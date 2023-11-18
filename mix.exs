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
      extra_applications: [:logger],
      mod: {WebrtcServer.Application, []}
    ]
  end

  defp deps do
    [
    ]
  end
end
