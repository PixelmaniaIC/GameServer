defmodule GameServerTest do
  use ExUnit.Case
  doctest GameServer.Command
  doctest GameServer.UserState
  
  doctest PictureProcess.Cell
  doctest PictureProcess.Color
end
