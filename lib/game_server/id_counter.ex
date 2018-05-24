defmodule GameServer.IDCounter do
  @moduledoc """
  Module for generating new unique id
  """
  use Agent

  @doc """
  Creates new pid with default "0" value
  """
  def start_link do
    Agent.start_link(fn -> "0" end)
  end

  @doc """
  Generates new id.
  Function converts string to integer that is in `state`.
  Increment it by one. Converts to string and saves in state.

  ## Examples

    iex> {:ok, state} = GameServer.IDCounter.start_link
    iex> GameServer.IDCounter.generate_id(state)
    "1"
    iex> GameServer.IDCounter.generate_id(state)
    "2"
  """
  def generate_id(state) do
    Agent.update(state, &update_string(&1))
    Agent.get(state, fn(x) -> x end)
  end

  @doc """
  Convert string to integer and increment it by one.
  """
  defp update_string(str) do
    {int, ""} = Integer.parse(str)
    to_string(int + 1)
  end
end
