defmodule GameServer.IDCounter do
  @moduledoc """
    Module for generating new id
  """
  use Agent

  def start_link do
    Agent.start_link(fn -> "0" end)
  end

  def generate_id(bucket) do
    Agent.update(bucket, &update_string(&1))
    Agent.get(bucket, fn(x) -> x end)
  end

  defp update_string(str) do
    {int, ""} = Integer.parse(str)
    to_string(int + 1)
  end
end
