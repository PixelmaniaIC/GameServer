defmodule GameServer.StatesKeeper do
  @moduledoc """
    Module that manages all important components
  """

  alias GameServer.Constants, as: Constants

  @doc """
  Returns state with generated components
  """
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

  @doc """
  Returns id counter from the `state`
  """
  def id_counter(states), do: Map.get(states, "id_counter")

  @doc """
  Returns picture state from the `state`
  """
  def picture_state(states), do: Map.get(states, "picture_state")

  @doc """
  Returns clients pid state from the `state`
  """
  def clients_pid(states), do: Map.get(states, "clients_pid")

  @doc """
  Returns users state from the `state`
  """
  def users_state(states), do: Map.get(states, "users_state")

  @doc """
  Returns current picture state from the `state`
  """
  def current_picture_state(states), do: Map.get(states, "current_picture_state")

  @doc """
  Returns game status from the `state`
  """
  def game_status(states), do: Map.get(states, "game_status")

  @doc """
  Returns game pid from the `state`
  """
  def game_pid(states), do: Map.get(states, "game_pid")
end
