defmodule GameServer.StatesKeeper do
  alias GameServer.Constants, as: Constants

  def inialize(game_pid) do
    states = %{}
    # Clients ids
    {:ok, clients_pid} = GameServer.Clients.start_link()
    states = Map.put(states, "clients_pid", clients_pid)

    {_, picture_parts} = Constants.picture_side() |> PictureProcess.process()

    # Picture state
    picture_state = PictureProcess.get_state(picture_parts)
    states = Map.put(states, "picture_state", picture_state)

    # Current board (picture) state
    current_picture_state = PictureProcess.get_state(picture_parts)
    states = Map.put(states, "current_picture_state", current_picture_state)

    # Id counter
    {:ok, id_counter} = GameServer.IDCounter.start_link()
    states = Map.put(states, "id_counter", id_counter)

    # users_state
    {:ok, users_state} = GameServer.UserState.start_link()
    states = Map.put(states, "users_state", users_state)

    # status of the game
    {:ok, game_status} = GameServer.GameStatus.start_link()
    states = Map.put(states, "game_status", game_status)

    Map.put(states, "game_pid", game_pid)
  end

  def id_counter(states), do: Map.get(states, "id_counter")

  def picture_state(states), do: Map.get(states, "picture_state")

  def clients_pid(states), do: Map.get(states, "clients_pid")

  def users_state(states), do: Map.get(states, "users_state")

  def current_picture_state(states), do: Map.get(states, "current_picture_state")

  def game_status(states), do: Map.get(states, "game_status")

  def game_pid(states), do: Map.get(states, "game_pid")
end
