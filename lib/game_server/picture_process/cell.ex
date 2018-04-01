defmodule PictureProcess.Cell do
  alias PictureProcess.Color, as: Color

  defstruct [:r, :g, :b, :a, :index]

  def get_distance(%Color{r: r1, g: g1, b: b1}, %Color{r: r2, g: g2, b: b2}) do
    :math.pow(r1 - r2, 2) + :math.pow(g1 - g2, 2) + :math.pow(b1 - b2, 2)
    |> :math.sqrt()
    |> round()
  end
end
