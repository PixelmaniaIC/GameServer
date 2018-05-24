defmodule GameServer.GameStatus do
  @moduledoc """
  Keeps status of game. It may be "started" or "finished"
  """
  use Agent

  @doc """
  Creating pid that includes info about status of the game.
  With default "started" status
  """
  def start_link do
    Agent.start_link(fn -> "started" end)
  end

  @doc """
  Retuns status of state

  ## Examples

    iex> {:ok, status} = GameServer.GameStatus.start_link
    iex> GameServer.GameStatus.get(status)
    "started"
  """
  def get(state) do
    Agent.get(state, fn(x) -> x end)
  end

  @doc """
  Change status of state to "finished"

  ## Examples

    iex> {:ok, status} = GameServer.GameStatus.start_link
    iex> GameServer.GameStatus.finish_game(status)
    iex> GameServer.GameStatus.get(status)
    "finished"
  """
  def finish_game(state) do
    Agent.update(state, fn(_) -> "finished" end)
  end
end
