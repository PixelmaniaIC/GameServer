defmodule GameServerTest do
  use ExUnit.Case
  doctest GameServer.Command
  doctest GameServer.UserState
  doctest GameServer.GameStatus
  doctest GameServer.IDCounter

  doctest PictureProcess.Cell
  doctest PictureProcess.Color
end
