defmodule PictureProcess.State do
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

  def filled_cells(bucket) do
    Agent.get(bucket, fn(x) -> Enum.filter(x, fn({k, v}) -> v.status == 1 end)
                               |> Enum.count
                      end)
  end
end
