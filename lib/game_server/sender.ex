defmodule GameServer.Sender do
  @moduledoc """
  Module that provides functions for sending messages to clients
  """

  @doc """
  Broadcasts `message` to clients
  """
  def send({:broadcast, message, clients}) do
    broadcast(message, clients)
  end

  @doc """
  Broadcasts `message` to clients with 0.5 sec delay
  """
  def send({:timer_commands, message, clients, add_func}) do
    Enum.each(message, fn(x) ->
      :timer.sleep(500)
      broadcast(x, clients)
    end)

    add_func.()
  end

  @doc """
  Broadcasts `message` to clients expect the client with `id`
  """
  def send({:except_sender, message, clients, id}) do
    send_except(message, clients, id)
  end

  @doc """
  Sends `message` to the client
  """
  def send({:client, message, client}) do
    send_to(message, client)
  end

  @doc """
  Sends `message` to the client
  """
  def send_to(message, client) when is_bitstring(message) do
    :gen_tcp.send(client, "#{message}\r\n")
  end

  @doc """
  Sends `messages` to the clients
  """
  def send_to(message, client) when is_list(message) do
    line = Enum.join(message, "\r\n")
    :gen_tcp.send(client, "#{line}\r\n")
  end

  @doc """
  Broadcasts `line` to clients expect the client with `id`
  """
  def send_except(line, clients_pid, except_id) do
    clients_pid
    |> GameServer.Clients.get_except(except_id)
    |> Enum.each(&send_to(line, &1))
  end

  @doc """
  Broadcasts `line` to clients expect the client with `id`
  """
  def broadcast(line, clients) do
    clients
    |> GameServer.Clients.get_all
    |> Enum.each(&send_to(line, &1))
  end
end
