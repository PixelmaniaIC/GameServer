defmodule GameServer.Clients do
  @moduledoc """
  Keeps list of all entered clients
  """
  use Agent

  @doc """
  Creating pid
  """
  def start_link do
    Agent.start_link(fn -> %{} end)
  end

  @doc """
  Returns client by `key`
  """
  def get(state, key) do
    Agent.get(state, &Map.get(&1, key))
  end

  @doc """
  Puts client to pid's state
  """
  def put(state, key, value) do
    Agent.update(state, &Map.put(&1, key, value))
  end

  @doc """
  Returns all client except clint with `key`
  """
  def get_except(state, key) do
    Agent.get(state, &all_except(&1, key))
  end

  @doc """
  Removes client with `key`
  """
  def delete(state, key) do
    Agent.update(state, &Map.delete(&1, key))
  end

  @doc """
  Returns number of clients in `state`
  """
  def size(state) do
    Agent.get(state, &get_size(&1))
  end

  @doc """
  Returns all clients
  """
  def get_all(state) do
    Agent.get(state, &Map.values(&1))
  end

  @doc """
  Returns state with generated components
  """
  defp all_except(map, key) do
    map
    |> Map.to_list
    |> Enum.filter(fn({k, _v}) -> k != key end )
    |> Enum.map(fn({_key, value}) -> value end)
  end

  @doc """
  Returns size of elements in the `map`
  """
  def get_size(map) do
    map
    |> Map.to_list
    |> length
  end
end
