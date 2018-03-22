defmodule GameServer.ErrorHandler do
  require Logger

  def process(socket, clients_pid, id, :enotconn) do
    Logger.info "Error exit"
    GameServer.Clients.delete(clients_pid, id)
    exit(:shutdown)
  end

  def process(socket, clients_pid, id, :closed) do
    Logger.info "Error exit"
    GameServer.Clients.delete(clients_pid, id)
    Logger.info "#{id} deleted from list"
    exit(:shutdown)
  end
end
