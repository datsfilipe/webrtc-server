defmodule WebrtcServer.Room do
  alias WebrtcServer.Store
  import Jason

  def match(data) do
    case decode!(data) do
      # format: {"type": "create", "user_id": user_id}
      %{"type" => "create", "user_id" => user_id} ->
        room_id = UUID.uuid4()
        create(room_id, user_id)
      # format: {"type": "join", "room_id": room_id, "user_id": user_id}
      %{"type" => "join", "room_id" => room_id, "user_id" => user_id} ->
        join(room_id, user_id)
      # format: {"type": "leave", "room_id": room_id, "user_id": user_id}
      %{"type" => "leave", "room_id" => room_id, "user_id" => user_id} ->
        leave(room_id, user_id)
      # format: {"type": "delete", "room_id": room_id, "user_id": user_id}
      %{"type" => "delete", "room_id" => room_id, "user_id" => user_id} ->
        delete(room_id, user_id)
      _ ->
        {:invalid_message}
    end
  end

  defp create(room_id, user_id) do
    case Store.get!(room_id) do
      {:ok, _} ->
        {:room_already_exists}
      {:not_found} ->
        Store.put!(room_id, %{"owner" => user_id, "users" => [user_id]})
        {:ok, %{room_id: room_id}}
    end
  end

  defp join(room_id, user_id) do
    case Store.get!(room_id) do
      {:ok, room} ->
        case room["users"] do
          [] ->
            {:room_has_no_users}
          users ->
            case Enum.member?(users, user_id) do
              true ->
                {:user_already_joined}
              false ->
                Store.put!(room_id, Map.put(room, "users", [user_id | users]))
                {:ok, %{room_id: room_id}}
            end
        end
      {:not_found} ->
        {:room_not_found}
    end
  end

  defp leave(room_id, user_id) do
    case Store.get!(room_id) do
      {:ok, room} ->
        case room["users"] do
          [] ->
            {:room_has_no_users}
          users ->
            case Enum.member?(users, user_id) do
              true ->
                Store.put!(room_id, Map.put(room, "users", List.delete(users, user_id)))
                {:ok, %{room_id: room_id}}
              false ->
                {:user_not_joined}
            end
        end
      {:not_found} ->
        {:room_not_found}
    end
  end

  defp delete(room_id, user_id) do
    case Store.get!(room_id) do
      {:ok, room} ->
        case room["owner"] do
          ^user_id ->
            Store.delete!(room_id)
            {:ok, %{room_id: room_id}}
          _ ->
            {:user_not_owner}
        end
      {:not_found} ->
        {:room_not_found}
    end
  end

  def recover(room_id) do
    case Store.get!(room_id) do
      {:ok, room} ->
        {:ok, %{room_id: room_id}}
      {:not_found} ->
        {:room_not_found}
    end
  end
end
