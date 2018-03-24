defmodule GameServer.Leaderboard do
  use Agent

  def start_link do
    Agent.start_link(fn -> %{} end)
  end

  def new_player(bucket, key) do
    Agent.update(bucket, &Map.put(&1, key, 0))
  end

  def update(bucket, key, d_score) do
    Agent.update(bucket, &Map.update!(&1, key, fn(cur) -> cur + d_score end))
  end

  def get(bucket, key) do
    Agent.get(bucket, &Map.get(&1, key))
  end

  def put(bucket, key, value) do
    Agent.update(bucket, &Map.put(&1, key, value))
  end

  def to_points(number) when number <= 100, do: 100 - number
  def to_points(number) when (number <= 200 and number) > 100, do: -10
  def to_points(number) when number > 200, do: -50
end
