defmodule GameServer.Command do
  alias GameServer.Message, as: Message

  def parse(json) do
    Poison.decode!(json, as: %Message{})
  end

  def image_url(url, id) do
    %Message{playerId: id, networkName: "UrlReceiver", payload: url}
  end

  def set_changed_state(cubes, id) do
    {:ok, json_cubes} = JSON.encode(%{cubes: cubes})

    %Message{
      playerId: id,
      networkName: "ChangedImageInitializer",
      payload: json_cubes
    }
  end

  def set_picture_state(cubes, id) do
    {:ok, json_cubes} = JSON.encode(%{cubes: cubes})
    %Message{
      playerId: id,
      networkName: "ImageInitializer",
      payload: json_cubes
    }
  end

  def set_id(id) do
    %Message{playerId: id, networkName: "PlayerIdProcessor"}
  end

  def change_color(id, payload) do
    %Message{
      playerId: id,
      networkName: "ColorChanger",
      payload: payload
    }
  end

  def set_users_state(users, id) do
    {:ok, json} = JSON.encode(%{users: users})
    %Message{
      playerId: id,
      networkName: "UsersInitializer",
      payload: json
    }
  end

  def add_user(id, name) do
    %Message{playerId: id, networkName: "UserInserter", payload: name}
  end

  def update_score(id, score) do
    %Message{playerId: id, networkName: "ScoreUpdater", payload: score}
  end
end
