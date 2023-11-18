defmodule WebrtcServer.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
    ]

    opts = [strategy: :rest_for_one, name: WebrtcServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
