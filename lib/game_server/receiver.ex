defmodule GameServer.Receiver do
  @moduledoc """
  Functions that handles messages from clients
  """

  alias GameServer.Message, as: Message
  alias GameServer.StatesKeeper, as: StatesKeeper
  alias GameServer.Constants, as: Constants

  @doc """
  Handles message from the ColorChanger. Updates game area, points of user.
  Also, if game all cells are filled, returns command to finish the game.
  """
  def receive(%Message{playerId: id, networkName: "ColorChanger", payload: payload}, states) do
    %PictureProcess.Cell{r: r, g: g, b: b, a: a, index: index} =
      Poison.decode!(payload, as: %PictureProcess.Cell{})

    distance =
      StatesKeeper.current_picture_state(states)
      |> PictureProcess.State.get(index)
      |> PictureProcess.Cell.get_distance(%PictureProcess.Color{r: r, g: g, b: b})
      |> GameServer.Leaderboard.to_points

    user_state = StatesKeeper.users_state(states)
    user_state |> GameServer.UserState.update_score(id, distance)

    picture_curr_state = StatesKeeper.current_picture_state(states)
    PictureProcess.State.put(picture_curr_state,
                              index,
                              %PictureProcess.Color{r: r, g: g, b: b, a: a, status: 1})

    {:ok, change_color_message} =
      GameServer.Command.change_color(id, payload)
      |> JSON.encode()

    {:ok, update_score_message} =
      GameServer.Command.update_score(id, distance, index)
      |> JSON.encode();

    message_list = [change_color_message, update_score_message]

    close_func = fn() -> end

    if PictureProcess.State.filled_cells(picture_curr_state) == (Constants.picture_parts + 1) do
      {:ok, end_game_message} =
        GameServer.Command.end_game()
        |> JSON.encode()

      StatesKeeper.game_status(states) |> GameServer.GameStatus.finish_game
      close_func = fn() ->
        StatesKeeper.game_pid(states) |> Process.exit(:kill)
      end

      message_list = List.insert_at(message_list, -1, end_game_message)
    end

    {:timer_commands, message_list, StatesKeeper.clients_pid(states), close_func}
  end

  @doc """
  Handles message from the NameSetter. Receives name of new user.
  Writes it to the state. Returns command to add new user to other clients.
  """
  def receive(%Message{playerId: id, networkName: "NameSetter", payload: name}, states) do
    StatesKeeper.users_state(states)
    |> GameServer.UserState.new_player(id, name)

    {:ok, json_message} = GameServer.Command.add_user(id, name) |> JSON.encode
    {:except_sender, json_message, StatesKeeper.clients_pid(states), id}
  end

  @doc """
  Handles message from the ImageDownloaded. Receives notification that user
  downloaded the picture.
  Returns command to user to load current state of picure.
  """
  def receive(%Message{playerId: id, networkName: "ImageDownloaded", payload: _}, states) do
    picture_curr_state = StatesKeeper.current_picture_state(states)
    {:ok, message} =
      (0..Constants.picture_parts)
      |> Enum.reduce([], fn(index, list) ->
        indexed = PictureProcess.State.get(picture_curr_state, index)
        [Map.update!(indexed, :index, fn(_) -> index end) | list ] end)
      |> Enum.filter(fn(x) -> x.status == 1 end)
      |> GameServer.Command.changed_state(id)
      |> JSON.encode()

    client = StatesKeeper.clients_pid(states) |> GameServer.Clients.get(id)
    {:client, message, client}
  end
end
