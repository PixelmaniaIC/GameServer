defmodule GameServer.UserState do
  use Agent
  alias GameServer.User, as: User

  def start_link do
    Agent.start_link(fn -> %{} end)
  end

  def new_player(bucket, key, name) do
    Agent.update(bucket, &Map.put(&1, key, %User{name: name, score: 0}))
  end

  def update_score(bucket, key, d_score) do
    Agent.update(bucket, &Map.update!(&1, key, fn(u) -> %User{u | score: d_score + u.score} end))
  end

  def get(bucket, key) do
    Agent.get(bucket, &Map.get(&1, key))
  end

  def to_points(number) when number <= 100, do: 100 - number
  def to_points(number) when (number <= 200 and number) > 100, do: -10
  def to_points(number) when number > 200, do: -50
end
