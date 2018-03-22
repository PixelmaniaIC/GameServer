# TODO: GOVNO
# I m gonna change this to keep state of picture
defmodule GameServer.PictureColor do
  @moduledoc """
    Keeps state of picture
  """

  use Agent

  def start_link do
    Agent.start_link(fn -> {0, 0, 0} end)
  end

  def get(bucket) do
    Agent.get(bucket, fn(rgb) -> rgb end )
  end

  def put(bucket, value) do
    Agent.update(bucket, fn(rgb) -> value end)
  end
end
