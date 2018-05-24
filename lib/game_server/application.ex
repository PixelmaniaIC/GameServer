defmodule GameServer.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Task.Supervisor, name: GameServer.TaskSupervisor},
      Supervisor.child_spec({Task, fn -> GameServer.accept(4040) end}, restart: :permanent)
    ]

    opts = [strategy: :one_for_one, name: GameServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
