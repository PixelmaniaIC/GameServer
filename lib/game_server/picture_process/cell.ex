defmodule PictureProcess.Cell do
  alias __MODULE__, as: Cell

  defstruct [:r, :g, :b, :a, :index]

  def get_distance(%PictureProcess.Color{r: r1, g: g1, b: b1}, %Cell{r: r2, g: g2, b: b2, index: _}) do
    ## TODO: DELETE THIS GOVNO
    r2 = r2 * 255 |> round()
    g2 = g2 * 255 |> round()
    b2 = b2 * 255 |> round()

    IO.puts "#{r1} #{r2} _____________"
    IO.puts "#{g1} #{g2} _____________"
    IO.puts "#{b1} #{b2} _____________"

    :math.pow(r1 - r2, 2) + :math.pow(g1 - g2, 2) + :math.pow(b1 - b2, 2)
    |> :math.sqrt()
    |> round()
  end
end
