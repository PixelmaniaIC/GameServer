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

    #TODO: Учесть случай, когда игрок не послал своего имени
    user_state = StatesKeeper.users_state(states)
    user_state |> GameServer.UserState.update_score(id, distance)

    {:ok, change_color_message} =
      GameServer.Command.change_color(id, payload)
      |> JSON.encode()

    {:ok, update_score_message} =
      GameServer.Command.update_score(id, distance)
      |> JSON.encode();

    message_list = [change_color_message, update_score_message]

    {:stupid_broadcast, message_list, StatesKeeper.clients_pid(states)}
  end

  def receive(%Message{playerId: id, networkName: "NameSetter", payload: name}, states) do
    StatesKeeper.users_state(states)
    |> GameServer.UserState.new_player(id, name)
    IO.puts "RECEIVED NAME #{name}"

    {:ok, json_message} = GameServer.Command.add_user(id, name) |> JSON.encode
    {:except_sender, json_message, StatesKeeper.clients_pid(states), id}
  end
end
