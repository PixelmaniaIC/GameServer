defmodule GameServer.Constants do
  @moduledoc """
  Module that includes all constants for the project
  """

  @doc """
  Returns number of segments that will be in one side of picture
  """
  def picture_side, do: 4

  @doc """
  Returns the index of last segment
  """
  def picture_parts, do: (picture_side() |> :math.pow(2) |> round) - 1
end
