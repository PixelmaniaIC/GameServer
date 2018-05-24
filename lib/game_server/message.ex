defmodule GameServer.Message do
  @moduledoc """
  This module describes messages
  A structure for communication with a client
  """

  @derive [Poison.Encoder]
  defstruct [:playerId, :networkName, :payload]

  @doc """
  Parses json to %GameServer.Message
  """
  def parse(json) do
    Poison.decode!(json, as: %GameServer.Message{})
  end
end
