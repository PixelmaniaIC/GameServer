defmodule GameServer.Command do
  @moduledoc """
  This module provides functions that build commands to client
  """

  alias GameServer.Message, as: Message

  @doc """
  Builds the command that includes url for image

  ## Examples

    iex> image = GameServer.Command.image_url("url", 1)
    iex> image.networkName
    "UrlReceiver"
    iex> image.playerId
    1
  """
  #TODO: not it's stub, in future we will receive it from http-server
  def image_url(url, id) do
    {:ok, json} = JSON.encode(%{url: url,
                                title: "Avengers III",
                                description: "Short movie description",
                                refLink: "https://www.youtube.com/watch?v=QwievZ1Tx-8cm"})

    %Message{playerId: id, networkName: "UrlReceiver", payload: json}
  end

  @doc """
  Builds the command that includes initial state of play area

  ## Examples

    iex> GameServer.Command.initial_state([], 10)
    %GameServer.Message{networkName: "ImageInitializer",
                        payload: ~s({\"cubes\":[]}),
                        playerId: 10}
  """
  def initial_state(cubes, id) do
    {:ok, json_cubes} = JSON.encode(%{cubes: cubes})

    %Message{
      playerId: id,
      networkName: "ImageInitializer",
      payload: json_cubes
    }
  end

  @doc """
  Builds the command that includes current state of play area

  ## Examples

    iex> GameServer.Command.changed_state([], 11)
    %GameServer.Message{networkName: "ChangedImageInitializer",
                        payload: ~s({\"cubes\":[]}),
                        playerId: 11}
  """
  def changed_state(cubes, id) do
    {:ok, json_cubes} = JSON.encode(%{cubes: cubes})

    %Message{
      playerId: id,
      networkName: "ChangedImageInitializer",
      payload: json_cubes
    }
  end

  @doc """
  Builds the command that includes new id of player

  ## Examples

    iex> GameServer.Command.set_id(3)
    %GameServer.Message{networkName: "PlayerIdProcessor", payload: nil, playerId: 3}
  """
  def set_id(id) do
    %Message{playerId: id, networkName: "PlayerIdProcessor"}
  end

  @doc """
  Builds the command that includes new color for user

  ## Examples

    iex> GameServer.Command.change_color(3, "blue")
    %GameServer.Message{networkName: "ColorChanger", payload: "blue", playerId: 3}
  """
  def change_color(id, payload) do
    %Message{
      playerId: id,
      networkName: "ColorChanger",
      payload: payload
    }
  end

  @doc """
  Builds the command that includes info about all playing users

  ## Examples

    iex> GameServer.Command.users_state(["Cookie Monster", "Bert", "Ernie"], 3)
    %GameServer.Message{
      networkName: "UsersInitializer",
      payload: ~s({"users":["Cookie Monster","Bert","Ernie"]}),
      playerId: 3
    }
  """
  def users_state(users, id) do
    {:ok, json} = JSON.encode(%{users: users})

    %Message{
      playerId: id,
      networkName: "UsersInitializer",
      payload: json
    }
  end

  @doc """
  Builds the command that includes name of new user

  ## Examples

    iex> GameServer.Command.add_user(5, "Cookie Monster")
    %GameServer.Message{
      networkName: "UserInserter",
      payload: "Cookie Monster",
      playerId: 5
    }
  """
  def add_user(id, name) do
    %Message{playerId: id, networkName: "UserInserter", payload: name}
  end

  @doc """
  Builds the command that includes name of new user

  ## Examples

    iex> GameServer.Command.add_user(5, "Cookie Monster")
    %GameServer.Message{
      networkName: "UserInserter",
      payload: "Cookie Monster",
      playerId: 5
    }
  """
  def update_score(id, score, index) do
    {:ok, json} = JSON.encode(%{score: score, index: index})

    %Message{playerId: id, networkName: "ScoreUpdater", payload: json}
  end

  @doc """
  Builds the command, that finishes the game

  ## Examples

    iex> GameServer.Command.end_game
    %GameServer.Message{
      networkName: "GameFinisher",
      payload: nil,
      playerId: nil
    }
  """
  def end_game do
    %Message{networkName: "GameFinisher"}
  end
end
