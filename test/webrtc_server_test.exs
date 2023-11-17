defmodule WebrtcServerTest do
  use ExUnit.Case
  doctest WebrtcServer

  test "greets the world" do
    assert WebrtcServer.hello() == :world
  end
end
