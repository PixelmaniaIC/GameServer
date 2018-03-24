defmodule GameServer.Receiver do
  alias GameServer.Message, as: Message
  alias GameServer.StatesKeeper, as: StatesKeeper

  def receive(%Message{playerId: id, networkName: "ColorChanger", payload: payload}, states) do
    user_cell = Poison.decode!(payload, as: %PictureProcess.Cell{})

    distance =
      StatesKeeper.picture_state(states)
      |> PictureProcess.State.get(Map.get(user_cell, :index))
      |> PictureProcess.Cell.get_distance(user_cell)
      |> GameServer.Leaderboard.to_points

    GameServer.Leaderboard.update(StatesKeeper.leaderboard(states), id, distance)
    {:ok, json_message} = JSON.encode(GameServer.Command.change_color(id, payload))
    {:broadcast, json_message, StatesKeeper.clients_pid(states)}
  end

  def receive(%Message{playerId: id, networkName: "NameSetter", payload: payload}, states) do
    IO.puts "SET NAME"
  end
end
