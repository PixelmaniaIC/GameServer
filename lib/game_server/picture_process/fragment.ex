defmodule PictureProcess.Fragment do
  alias PictureProcess.Color, as: Color

  def pixel_sum(image, range_x, range_y) do
    IO.inspect range_x
    IO.inspect range_y
    #y - axis
    Enum.reduce(range_x, Color.zero, fn(y, color_y) ->
      #x - axis
      color_sum_y =
        Enum.reduce(range_y, Color.zero, fn(x, color_x) ->
          tmp_color =
            ExPNG.Image.get_pixel(image, y, x)
            |> Color.to_color

          %Color{
            r: sum_color(:r, color_x, tmp_color),
            g: sum_color(:g, color_x, tmp_color),
            b: sum_color(:b, color_x, tmp_color),
            a: sum_color(:a, color_x, tmp_color)
          }
        end)

      %Color{
        r: sum_color(:r, color_y, color_sum_y),
        g: sum_color(:g, color_y, color_sum_y),
        b: sum_color(:b, color_y, color_sum_y),
        a: sum_color(:a, color_y, color_sum_y)
      }
    end)
  end

  def get_average(color, first..last) do
    diff = last - first + 1
    diviser = :math.pow(diff, 2) |> round

    %Color{
      r: ((Map.get(color, :r) / diviser) |> round),
      g: ((Map.get(color, :g) / diviser) |> round),
      b: ((Map.get(color, :b) / diviser) |> round),
      a: ((Map.get(color, :a) / diviser) |> round)
    }
  end

  def get_ranges(w, n) do
    parts = div(w, n)

    Enum.reduce(0..(n - 1), [], fn(x, list) -> [x*parts..((x + 1)*parts - 1) | list] end)
    |> Enum.reverse
  end

  defp conv(color) do
    Map.keys(color)
    |> Enum.filter(fn(key) -> key != :__struct__ end)
    |> Enum.reduce(color, fn(key, acc) -> %{ acc | key => 3 } end)
  end

  defp bits_to_tuple(<<r, g, b, a>>) do
    {r, g, b, a}
  end

  defp sum_color(atom, map1, map2) do
    Map.get(map1, atom) + Map.get(map2, atom)
  end
end
