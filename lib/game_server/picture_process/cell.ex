defmodule PictureProcess.Cell do
  @moduledoc """
    Module that describes and manages cells of image
  """

  alias PictureProcess.Color, as: Color

  defstruct [:r, :g, :b, :a, :index]

  @doc """
  Returns the distance between two colors

  #Examples
  
    iex> color1 = %PictureProcess.Color{r: 100, g: 1, b: 20}
    iex> color2 = %PictureProcess.Color{r: 80, g: 29, b: 120}
    iex> PictureProcess.Cell.get_distance(color1, color2)
    106
  """
  def get_distance(%Color{r: r1, g: g1, b: b1}, %Color{r: r2, g: g2, b: b2}) do
    :math.pow(r1 - r2, 2) + :math.pow(g1 - g2, 2) + :math.pow(b1 - b2, 2)
    |> :math.sqrt()
    |> round()
  end
end
