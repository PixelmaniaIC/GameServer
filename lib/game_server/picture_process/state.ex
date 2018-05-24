defmodule PictureProcess.State do
  @moduledoc """
  Functions for generating and working with the game image
  """
  use Agent

  @doc """
  Generates new pid with empty Map
  """
  def start_link do
    Agent.start_link(fn -> %{} end)
  end

  @doc """
  Returns certain cell by `key`
  """
  def get(bucket, key) do
    Agent.get(bucket, &Map.get(&1, key))
  end

  @doc """
  Puts cell in pid's state
  """
  def put(bucket, key, value) do
    Agent.update(bucket, &Map.put(&1, key, value))
  end

  @doc """
  Returns count of filled cells in the image
  """
  def filled_cells(bucket) do
    Agent.get(bucket, fn(x) -> Enum.filter(x, fn({k, v}) -> v.status == 1 end)
                               |> Enum.count
                      end)
  end
end
