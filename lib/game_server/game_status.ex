defmodule GameServer.GameStatus do
  @moduledoc """
    Keeps status of game
  """
  use Agent

  def start_link do
    Agent.start_link(fn -> "started" end)
  end

  def get(bucket) do
    Agent.get(bucket, fn(x) -> x end)
  end

  def finish_game(bucket) do
    Agent.update(bucket, fn(_) -> "finished" end)
  end
end
