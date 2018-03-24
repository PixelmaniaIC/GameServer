defmodule GameServer.Sender do
  def send_to(line, client) do
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
