defmodule WebrtcServer.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: WebrtcServer.Router,
        options: [port: Application.get_env(:webrtc_server, :port)]
      )
    ]

    opts = [strategy: :one_for_one, name: WebrtcServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
