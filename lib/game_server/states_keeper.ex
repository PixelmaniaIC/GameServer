defmodule GameServer.StatesKeeper do
  alias GameServer.Constants, as: Constants

  def inialize do
    states = %{}
    # Clients ids
    {:ok, clients_pid} = GameServer.Clients.start_link()
    states = Map.put(states, "clients_pid", clients_pid)

    # Picture state
    picture_state = Constants.picture_side() |> PictureProcess.process()
    states = Map.put(states, "picture_state", picture_state)

    # Id counter
    {:ok, id_counter} = GameServer.IDCounter.start_link()
    states = Map.put(states, "id_counter", id_counter)

    # users_state
    {:ok, users_state} = GameServer.UserState.start_link()
    Map.put(states, "users_state", users_state)
  end

  def id_counter(states), do: Map.get(states, "id_counter")

  def picture_state(states), do: Map.get(states, "picture_state")

  def clients_pid(states), do: Map.get(states, "clients_pid")

  def users_state(states), do: Map.get(states, "users_state")
end
