defmodule GameServer.StatesKeeper do
  def id_counter(states), do: Map.get(states, "id_counter")

  def picture_state(states), do: Map.get(states, "picture_state")

  def clients_pid(states), do: Map.get(states, "clients_pid")

  def leaderboard(states), do: Map.get(states, "leaderboard")
end
