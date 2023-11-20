defmodule WebrtcServer.SocketHandler do
  @behaviour :cowboy_websocket

  def init(req, state) do
    {:cowboy_websocket, req, state}
  end

  def websocket_init(_state) do
    state = %{}
    {:ok, state}
  end

  def websocket_handle({:text, "ping"}, state) do
    {:reply, {:text, "pong"}, state}
  end

  def websocket_handle({:text, _}, state) do
    {:reply, {:text, "Not implemented"}, state}
  end

  def websocket_info(info, state) do
    IO.inspect info
    {:ok, state}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end
end
