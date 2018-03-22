defmodule GameServer do
  require Logger

  @doc """
  Starts accepting connections on the given `port`.
  """
  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port,
                      [:binary, packet: :line, active: false, reuseaddr: true])

    {:ok, clients_pid} = GameServer.Clients.start_link()
    {:ok, picture_state} = GameServer.PictureColor.start_link()
    {:ok, id_counter} = GameServer.IDCounter.start_link()

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

    {:ok, pid} = Task.Supervisor.start_child(GameServer.TaskSupervisor,
                                              fn -> serve(client, clients_pid, id, picture_state) end)

    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket, clients_pid, picture_state, id_counter)
  end

  # Тут будем парсить тип комманды и реагировать
  defp serve(socket, clients_pid, id, picture_state) do
    case read_line(socket) do
      {:ok, data} ->
        GameServer.Message.parse(data)
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
