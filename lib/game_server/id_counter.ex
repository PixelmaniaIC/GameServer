defmodule GameServer.IDCounter do
  @moduledoc """
    Module for generating new id
  """
  use Agent

  def start_link do
    Agent.start_link(fn -> 0 end)
  end

  def generate_id(bucket) do
    Agent.update(bucket, fn(x) -> x + 1 end)
    Agent.get(bucket, fn(x) -> x end)
  end
end
