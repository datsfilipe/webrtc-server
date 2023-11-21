defmodule WebrtcServer.SocketHandler do
  import Jason
  @behaviour :cowboy_websocket

  def init(req, state) do
    {:cowboy_websocket, req, state}
  end

  def websocket_init(_state) do
    state = %{}
    {:ok, state}
  end

  def websocket_handle({:text, data}, state) do
    case WebrtcServer.Room.match(data) do
      {:ok, %{room_id: room_id}} ->
        {:reply, {:text, encode!(%{"room_id" => room_id})}, state}
      {:invalid_message} ->
        {:reply, {:text, encode!(%{"error" => "invalid message"})}, state}
      {:room_already_exists} ->
        {:reply, {:text, encode!(%{"error" => "room already exists"})}, state}
      {:room_has_no_users} ->
        {:reply, {:text, encode!(%{"error" => "room has no users"})}, state}
      {:user_already_joined} ->
        {:reply, {:text, encode!(%{"error" => "user already joined"})}, state}
      {:room_not_found} ->
        {:reply, {:text, encode!(%{"error" => "room not found"})}, state}
      {:user_not_joined} ->
        {:reply, {:text, encode!(%{"error" => "user not joined"})}, state}
      _ ->
        {:reply, {:text, encode!(%{"error" => "message does not match any pattern"})}, state}
    end
  end

  def websocket_info(info, state) do
    IO.puts("Websocket info: #{inspect(info)}")
    {:ok, state}
  end

  def terminate(reason, _req, _state) do
    IO.puts("Terminating websocket: #{inspect(reason)}")
    :ok
  end
end
