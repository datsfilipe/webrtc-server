defmodule WebrtcServerTest.Router do
  use ExUnit.Case, async: true
  use Plug.Test

  test "handle request '/'" do
    conn = conn(:get, "/")
      |> WebrtcServer.Router.call([])
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "Hello, world!"
  end

  test "handle request '/foo'" do
    conn = conn(:get, "/foo")
      |> WebrtcServer.Router.call([])
    assert conn.state == :sent
    assert conn.status == 404
    assert conn.resp_body == "oops"
  end
end
