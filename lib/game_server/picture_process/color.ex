defmodule PictureProcess.Color do
  alias __MODULE__, as: Color

  defstruct [:r, :g, :b, :a, :status, :index]

  def to_color(<<r, g, b, a>>) do
    %Color{r: r, g: g, b: b, a: a}
  end

  def zero() do
    %Color{r: 0, g: 0, b: 0, a: 0}
  end
end
