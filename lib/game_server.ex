defmodule GameServer do
  require Logger

  alias GameServer.Constants, as: Constants
  alias GameServer.StatesKeeper, as: StatesKeeper

  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port,
                      [:binary, packet: :line, active: false, reuseaddr: true])

    # Initialize states
    states = StatesKeeper.inialize()
    
    IO.inspect(states)
    Logger.info "Accepting connections on port #{port}"
    loop_acceptor(socket, states)
  end

  defp loop_acceptor(socket, states) do
    {:ok, client} = :gen_tcp.accept(socket)

    id = StatesKeeper.id_counter(states) |> GameServer.IDCounter.generate_id()
    StatesKeeper.leaderboard(states) |> GameServer.Leaderboard.new_player(id)

    StatesKeeper.clients_pid(states) |> GameServer.Clients.put(id, client)
    Logger.info "new connection with #{id}"

    # WILL DELETE: GIVE ID TO USER
    message = GameServer.Command.set_id(id)
    {:ok, json} = JSON.encode(message);
    GameServer.Sender.send_to(json, client)

    # WILL DELETE: ADD USER TO LEADERBOARD
    StatesKeeper.leaderboard(states)
    |> GameServer.Leaderboard.new_player(id)

    :timer.sleep(1000)

    # WILL DELETE: GIVE URL TO USER
    url = PictureProcess.get_url
    {:ok, json} =
      GameServer.Command.image_url(url, id)
      |> JSON.encode
    GameServer.Sender.send_to(json, client)

    :timer.sleep(1000)

    # WILL DELETE: GIVE PICTURE STATE TO USER
    picture_state = StatesKeeper.picture_state(states)
    message =
      (0..Constants.picture_parts)
      |> Enum.reduce([], fn(index, list) ->
        [PictureProcess.State.get(picture_state, index) | list ] end)
      |> GameServer.Command.set_picture_state(id)

    {:ok, json} = JSON.encode(message)
    GameServer.Sender.send_to(json, client)

    {:ok, pid} = Task.Supervisor.start_child(GameServer.TaskSupervisor,
                                              fn -> serve(client, id, states) end)

    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket, states)
  end

  # Тут будем парсить тип комманды и реагировать
  defp serve(socket, id, states) do
    clients_pid = StatesKeeper.clients_pid(states)

    case read_line(socket) do
      {:ok, data} ->
        GameServer.Message.parse(data)
        |> GameServer.Receiver.receive(states)
        |> GameServer.Sender.send

        Logger.info "#{id}. #{data}"

        #GameServer.Sender.broadcast(data, clients_pid)
      {:error, error} ->
         GameServer.ErrorHandler.process(socket, clients_pid, id, error)
    end

    serve(socket, id, states)
  end

  defp read_line(socket) do
    :gen_tcp.recv(socket, 0)
  end
end
