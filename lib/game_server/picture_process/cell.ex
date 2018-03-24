defmodule PictureProcess.Cell do
  alias __MODULE__, as: Cell

  defstruct [:r, :g, :b, :a, :index]

  def get_distance(%PictureProcess.Color{r: r1, g: g1, b: b1}, %Cell{r: r2, g: g2, b: b2, index: _}) do
    :math.pow(r1 - r2, 2) + :math.pow(g1 - g2, 2) + :math.pow(b1 - b2, 2)
    |> :math.sqrt()
    |> round()
  end
end
