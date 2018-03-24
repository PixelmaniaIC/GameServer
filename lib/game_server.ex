defmodule GameServer do
  require Logger

  alias GameServer.Constants, as: Constants

  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port,
                      [:binary, packet: :line, active: false, reuseaddr: true])

    {:ok, clients_pid} = GameServer.Clients.start_link()
    picture_state = Constants.picture_side() |> PictureProcess.process()
    {:ok, id_counter} = GameServer.IDCounter.start_link()

    IO.inspect(picture_state)
    Logger.info "Accepting connections on port #{port}"
    loop_acceptor(socket, clients_pid, picture_state, id_counter)
  end

  defp loop_acceptor(socket, clients_pid, picture_state, id_counter) do
    {:ok, client} = :gen_tcp.accept(socket)

    id = GameServer.IDCounter.generate_id(id_counter)
    GameServer.Clients.put(clients_pid, id, client)
    Logger.info "new connection with #{id}"

    # WILL DELETE: GIVE ID TO USER
    message = GameServer.Command.set_id(id)
    {:ok, json} = JSON.encode(message);
    GameServer.Sender.send_to(json, client)

    :timer.sleep(1000)

    # WILL DELETE: GIVE URL TO USER
    url = PictureProcess.get_url
    {:ok, json} =
      GameServer.Command.image_url(url, id)
      |> JSON.encode
    GameServer.Sender.send_to(json, client)

    :timer.sleep(1000)

    # WILL DELETE: GIVE PICTURE STATE TO USER
    message =
      (0..Constants.picture_parts)
      |> Enum.reduce([], fn(index, list) ->
        [PictureProcess.State.get(picture_state, index) | list ] end)
      |> GameServer.Command.picture_state(id)

    {:ok, json} = JSON.encode(message)
    GameServer.Sender.send_to(json, client)

    {:ok, pid} = Task.Supervisor.start_child(GameServer.TaskSupervisor,
                                              fn -> serve(client, clients_pid, id, picture_state) end)

    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket, clients_pid, picture_state, id_counter)
  end

  # Тут будем парсить тип комманды и реагировать
  defp serve(socket, clients_pid, id, picture_state) do
    case read_line(socket) do
      {:ok, data} ->
        #GameServer.Message.parse(data)
        #|> GameServer.Command.run(picture_state)

        Logger.info "#{id}. #{data}"


        GameServer.Sender.send_except(data, clients_pid, id)
      {:error, error} ->
         GameServer.ErrorHandler.process(socket, clients_pid, id, error)
    end

    serve(socket, clients_pid, id, picture_state)
  end

  defp read_line(socket) do
    :gen_tcp.recv(socket, 0)
  end
end
