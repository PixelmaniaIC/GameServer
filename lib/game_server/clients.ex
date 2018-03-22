defmodule GameServer.Clients do
  @moduledoc """
    Keeps list of all entered clients
  """
  use Agent

  def start_link do
    Agent.start_link(fn -> %{} end)
  end

  def get(bucket, key) do
    Agent.get(bucket, &Map.get(&1, key))
  end

  def put(bucket, key, value) do
    Agent.update(bucket, &Map.put(&1, key, value))
  end

  def get_except(bucket, key) do
    Agent.get(bucket, &all_except(&1, key))
  end

  def delete(bucket, key) do
    Agent.update(bucket, &Map.delete(&1, key))
  end

  def size(bucket) do
    Agent.get(bucket, &get_size(&1))
  end

  def all_except(map, key) do
    map
    |> Map.to_list
    |> Enum.filter(fn({k, _v}) -> k != key end )
    |> Enum.map(fn({_key, value}) -> value end)
  end

  def get_size(map) do
    map
    |> Map.to_list
    |> length
  end
end
