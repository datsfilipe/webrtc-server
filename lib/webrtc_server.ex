defmodule WebrtcServer do
  import WebrtcServer.Router

  require Record
  Record.defrecord :httpd, Record.extract(:mod, from_lib: "inets/include/httpd.hrl")

  def child_spec(_) do
    opts = [
      server_name: 'webrtc_server',
      server_root: '/tmp',
      document_root: '/tmp',
      port: 3000,
      modules: [__MODULE__]
    ]

    args = [:httpd, opts]

    %{
      id: make_ref(),
      start: {:inets, :start, args},
    }
  end

  def unquote(:do)(data) do
    {status, body} = match(httpd(data, :request_uri))
    {:proceed, [response: {status, body}]}
  end
end
