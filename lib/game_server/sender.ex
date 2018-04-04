defmodule GameServer.Sender do
  def send({:broadcast, message, clients}) do
    IO.puts "we are sending next message:"
    IO.inspect message
    broadcast(message, clients)
  end

  # TODO: This solution was made because of bug in client!!!
  def send({:stupid_broadcast, message, clients, close_func}) do
    Enum.each(message, fn(x) ->
      IO.puts "we are stupidly broadcasting"
      IO.inspect message
      :timer.sleep(500)
      broadcast(x, clients)
    end)

    close_func.()
  end

  def send({:except_sender, message, clients, id}) do
    IO.puts "we are sending expect_one message:"
    IO.inspect message
    send_except(message, clients, id)
  end

  def send({:client, message, client}) do
    IO.puts "we are sending client message:"
    IO.inspect message

    send_to(message, client)
  end

  def send_to(message, client) when is_bitstring(message) do
    :gen_tcp.send(client, "#{message}\r\n")
  end

  def send_to(message, client) when is_list(message) do
    line = Enum.join(message, "\r\n")
    :gen_tcp.send(client, "#{line}\r\n")
  end

  def send_except(line, clients_pid, except_id) do
    clients_pid
    |> GameServer.Clients.get_except(except_id)
    |> Enum.each(&send_to(line, &1))
  end

  def broadcast(line, clients) do
    clients
    |> GameServer.Clients.get_all
    |> Enum.each(&send_to(line, &1))
  end
end
