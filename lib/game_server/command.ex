defmodule GameServer.Command do
  def parse(json) do
    Poison.decode!(json, as: %GameServer.Message{})
  end

  def run(command, picture_state) do
    %{:playerId => _, :r => r, :g => g, :b => b} = command
    GameServer.PictureColor.put(picture_state, {r, g, b})
  end

  def image_url(url, id) do
    %{playerId: id, networkName: "UrlReceiver", payload: url}
  end

  def set_id(id) do
    %GameServer.Message{playerId: id, networkName: "PlayerIdProcessor"}
  end

  # TODO: must rewrite
  def change_color(id, {r, g, b}) do
    %GameServer.Message{playerId: id,
                        networkName: "ColorChanger",
                        payload: JSON.decode(%{r: r, g: g, b: b})}
  end
end
