defmodule WebrtcServer do
  require Record
  
  Record.defrecord :httpd, Record.extract(:mod, from_lib: "inets/include/httpd.hrl")

  def child_spec(_) do
    opts = [
      server_name: 'webrtc_server',
      server_root: '/tmp',
      document_root: '/tmp',
      port: 8080,
      modules: [__MODULE__]
    ]

    args = [:httpd, opts]

    %{
      id: make_ref(),
      start: {:inets, :start, args},
    }
  end

  def unquote(:do)(data) do
    uri = httpd(data, :request_uri)
    IO.puts("uri: #{uri}")

    response =
      case httpd(data, :request_uri) do
        '/' ->
          {200, 'OK'}
        _ ->
          {404, 'Not Found'}
      end
    {:proceed, [response: response]}
  end
end
