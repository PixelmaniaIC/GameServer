defmodule GameServer do
  @moduledoc """
  Module that manages with tcp-connections
  """

  require Logger

  alias GameServer.Constants, as: Constants
  alias GameServer.StatesKeeper, as: StatesKeeper

  @doc """
  Opens `port` for tcp-connections
  """
  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port,
                      [:binary, packet: :line, active: false, reuseaddr: true])

    states = StatesKeeper.inialize(self())

    Logger.info "Accepting connections on port #{port}"

    loop_acceptor(socket, states)
  end

  @doc """
  Establishes new connection. Generate id for this connection
  and sends current state of game to this client.
  """
  defp loop_acceptor(socket, states) do
    {:ok, client} = :gen_tcp.accept(socket)

    id = StatesKeeper.id_counter(states) |> GameServer.IDCounter.generate_id()

    StatesKeeper.clients_pid(states) |> GameServer.Clients.put(id, client)
    Logger.info "new connection with #{id}"

    init_commands = []

    # giving id to user
    {:ok, set_id} = GameServer.Command.set_id(id) |> JSON.encode()
    init_commands = List.insert_at(init_commands, -1, set_id)

    # all new users
    {:ok, all_users} =
      StatesKeeper.users_state(states)
      |> GameServer.UserState.get_all()
      |> Enum.map(fn({id, user}) ->
        %{id: id, name: user.name, score: user.score, online: user.online} end)
      |> GameServer.Command.users_state(id)
      |> JSON.encode
    init_commands = List.insert_at(init_commands, -1, all_users)

    # giving url to user
    {:ok, set_img_url} =
      PictureProcess.get_url
      |> GameServer.Command.image_url(id)
      |> JSON.encode

    init_commands = List.insert_at(init_commands, -1, set_img_url)

    # giving initial state to user
    picture_state = StatesKeeper.picture_state(states)
    message =
      (0..Constants.picture_parts)
      |> Enum.reduce([], fn(index, list) ->
        [PictureProcess.State.get(picture_state, index) | list ] end)
      |> GameServer.Command.initial_state(id)

    {:ok, set_pic_parts} = JSON.encode(message)
    init_commands = List.insert_at(init_commands, -1, set_pic_parts)

    IO.inspect init_commands

    Enum.each(init_commands, fn(mess) ->
      :timer.sleep(500)
      GameServer.Sender.send_to(mess, client)
    end)

    {:ok, pid} = Task.Supervisor.start_child(GameServer.TaskSupervisor,
                                              fn -> serve(client, id, states) end)

    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket, states)
  end

  @doc """
  Reads commands from client and reacts to them.
  """
  defp serve(socket, id, states) do
    case read_line(socket) do
      {:ok, data} ->
        Logger.info "#{id}. #{data}"

        GameServer.Message.parse(data)
        |> GameServer.Receiver.receive(states)
        |> IO.inspect
        |> GameServer.Sender.send

      {:error, error} ->
         GameServer.ErrorHandler.process(socket, states, id, error)
    end

    serve(socket, id, states)
  end

  @doc """
  Reads stream data from the socket
  """
  defp read_line(socket) do
    :gen_tcp.recv(socket, 0)
  end
end
