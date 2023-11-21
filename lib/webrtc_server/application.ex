defmodule WebrtcServer.Application do
  alias WebrtcServer.Store
  use Application

  @impl true
  def start(_type, _args) do
    Store.init()

    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: WebrtcServer.Router,
        options: [
          port: Application.get_env(:webrtc_server, :port),
          dispatch: dispatch()
        ]
      )
    ]

    opts = [strategy: :one_for_one, name: WebrtcServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
    
  defp dispatch do
    [
      {:_, [
        {"/ws", WebrtcServer.SocketHandler, []},
        {:_, Plug.Cowboy.Handler, {WebrtcServer.Router, []}}
      ]}
    ]
  end

  @impl true
  def stop(_state) do
    Store.terminate()
    :ok
  end
end
