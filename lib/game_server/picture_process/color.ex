defmodule PictureProcess.Color do
  @moduledoc """
  Module that provides functions to work with colors
  """

  alias __MODULE__, as: Color

  defstruct [:r, :g, :b, :a, :status, :index]

  @doc """
  Convert bits to Color

  ## Examples

    iex> PictureProcess.Color.to_color(<<10, 20, 30, 255>>)
    %PictureProcess.Color{r: 10, g: 20, b: 30, a: 255}
  """
  def to_color(<<r, g, b, a>>) do
    %Color{r: r, g: g, b: b, a: a}
  end

  @doc """
  Returns color with all args equal to zero

  ## Examples

    iex> PictureProcess.Color.zero
    %PictureProcess.Color{r: 0, g: 0, b: 0, a: 0}
  """
  def zero() do
    %Color{r: 0, g: 0, b: 0, a: 0}
  end
end
