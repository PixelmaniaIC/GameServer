defmodule GameServer.ErrorHandler do
  @moduledoc """
  This module implements functions that handle errors connected to network
  """

  require Logger

  alias GameServer.StatesKeeper, as: StatesKeeper
  alias GameServer.UserState, as: UserState

  @doc """
  Update users status to offline and closes socket connection
  """
  def process(_socket, states, id, :enotconn) do
    Logger.info "Error exit"

    IO.inspect StatesKeeper.users_state(states) |> UserState.get_all
    clear_user_info(states, id)
    IO.inspect StatesKeeper.users_state(states) |> UserState.get_all

    exit(:shutdown)
  end

  @doc """
  Update users status to offline and closes socket connection
  """
  def process(_socket, states, id, :closed) do
    Logger.info "Player exit"
    IO.inspect StatesKeeper.users_state(states) |> UserState.get_all

    clear_user_info(states, id)

    Logger.info "#{id} deleted from list"
    IO.inspect StatesKeeper.users_state(states) |> UserState.get_all

    exit(:shutdown)
  end

  @doc """
  Sets user's status to offline
  """
  defp clear_user_info(states, id) do
    StatesKeeper.clients_pid(states) |> GameServer.Clients.delete(id)

    users_state = StatesKeeper.users_state(states)
    if UserState.get(users_state, id) do
      UserState.user_offline(users_state, id)
    end
  end
end
