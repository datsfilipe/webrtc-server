defmodule WebrtcServer.Store do
  def init do
    :ets.new(:webrtc_server, [:named_table, :public, :protected])
  end

  def get!(key) do
    case :ets.lookup(:webrtc_server, key) do
      [{^key, value}] -> {:ok, value}
      [] -> {:not_found}
    end
  end

  def put!(key, value) do
    :ets.insert(:webrtc_server, {key, value})
    :ok
  end

  def delete!(key) do
    :ets.delete(:webrtc_server, key)
    :ok
  end

  def terminate() do
    :ets.delete(:webrtc_server)
    :ok
  end
end
