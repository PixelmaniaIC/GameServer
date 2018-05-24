defmodule GameServer.Leaderboard do
  @moduledoc """
  Function for mapping color difference to game points
  """

  def to_points(number) when number <= 100, do: 100 - number
  def to_points(number) when (number <= 200 and number) > 100, do: -10
  def to_points(number) when number > 200, do: -50
end
