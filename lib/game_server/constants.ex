defmodule GameServer.Constants do
  def picture_side, do: 4

  def picture_parts, do: (picture_side() |> :math.pow(2) |> round) - 1 
end
