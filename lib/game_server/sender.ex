defmodule GameServer.Sender do
  def send({:broadcast, message, clients}) do
    IO.puts "we are sending next message:"
    IO.inspect message
    broadcast(message, clients)
  end

  def send({:except_sender, message, clients, id}) do
    IO.puts "we are sending expect_one message:"
    IO.inspect message
    send_except(message, clients, id)
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
