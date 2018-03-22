defmodule GameServer.Message do
  @derive [Poison.Encoder]
  defstruct [:playerId, :networkName, :payload]

  def parse(json) do
    Poison.decode!(json, as: %GameServer.Message{})
  end
end
