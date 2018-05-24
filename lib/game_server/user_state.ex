defmodule GameServer.UserState do
  @moduledoc """
    Functions for generating and working with users
  """

  use Agent
  alias GameServer.User, as: User

  @doc """
  Generates new pid with empty Map
  """
  def start_link do
    Agent.start_link(fn -> %{} end)
  end

  @doc """
  Creates and adds new user to state

  ## Examples

    iex> {:ok, state} = GameServer.UserState.start_link()
    iex> GameServer.UserState.new_player(state, 1, "Hasselhoff")
    iex> GameServer.UserState.get(state, 1)
    %GameServer.User{name: "Hasselhoff", online: true, score: 0}
  """
  def new_player(state, key, name) do
    Agent.update(state, &Map.put(&1, key, %User{name: name, score: 0, online: true}))
  end

  @doc """
  Creates and adds new user to state

  ## Examples

    iex> {:ok, state} = GameServer.UserState.start_link()
    iex> GameServer.UserState.new_player(state, 1, "Hasselhoff")
    iex> GameServer.UserState.update_score(state, 1, 300)
    iex> GameServer.UserState.get(state, 1)
    %GameServer.User{name: "Hasselhoff", online: true, score: 300}
  """
  def update_score(state, key, d_score) do
    Agent.update(state, &Map.update!(&1, key, fn(u) -> %User{u | score: d_score + u.score} end))
  end

  @doc """
  Change user's online field to `offline`

  ## Examples

    iex> {:ok, state} = GameServer.UserState.start_link()
    iex> GameServer.UserState.new_player(state, 1, "Hasselhoff")
    iex> GameServer.UserState.user_offline(state, 1)
    iex> GameServer.UserState.get(state, 1)
    %GameServer.User{name: "Hasselhoff", online: false, score: 0}
  """
  def user_offline(state, key) do
    Agent.update(state, &Map.update!(&1, key, fn(u) -> %User{u | online: false} end))
  end

  @doc """
  Returns all users from the `state`

  ## Examples

    iex> {:ok, state} = GameServer.UserState.start_link()
    iex> GameServer.UserState.new_player(state, 1, "Hasselhoff")
    iex> GameServer.UserState.new_player(state, 2, "Pamela")
    iex> GameServer.UserState.get_all(state)
    %{
      1 => %GameServer.User{name: "Hasselhoff", online: true, score: 0},
      2 => %GameServer.User{name: "Pamela", online: true, score: 0}
    }
  """
  def get_all(state) do
    Agent.get(state, &(&1))
  end

  @doc """
  Returns certain user by key

  ## Examples

    iex> {:ok, state} = GameServer.UserState.start_link()
    iex> GameServer.UserState.new_player(state, 1, "Hasselhoff")
    iex> GameServer.UserState.get(state, 1)
    %GameServer.User{name: "Hasselhoff", online: true, score: 0}
  """
  def get(state, key) do
    Agent.get(state, &Map.get(&1, key))
  end
end
