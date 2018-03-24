defmodule GameServer.Command do
  def parse(json) do
    Poison.decode!(json, as: %GameServer.Message{})
  end

  def image_url(url, id) do
    %{playerId: id, networkName: "UrlReceiver", payload: url}
  end

  def set_picture_state(cubes, id) do
    {:ok, json_cubes} = JSON.encode(%{cubes: cubes})
    %GameServer.Message{
      playerId: id,
      networkName: "ImageInitializer",
      payload: json_cubes
    }
  end

  def set_id(id) do
    %GameServer.Message{playerId: id, networkName: "PlayerIdProcessor"}
  end

  def change_color(id, payload) do
    %GameServer.Message{
      playerId: id,
      networkName: "ColorChanger",
      payload: payload
    }
  end
end
