defmodule PictureProcess do
  alias PictureProcess.Fragment, as: Fragment
  alias PictureProcess.State, as: State

  # TODO: rewrite, this function do many actions
  def process(n) do

    Application.ensure_all_started :inets

    {:ok, resp} = :httpc.request(:get, {image_url(), []}, [], [body_format: :binary])
    {{_, 200, 'OK'}, _headers, body} = resp

    image = ExPNG.decode(body)

    ranges = Map.get(image, :width)
    |> Fragment.get_ranges(n)

    Enum.map(ranges, fn(range_y) ->
      Enum.map(ranges, fn(range_x) ->
          Fragment.pixel_sum(image, range_x, range_y)
          |>Fragment.get_average(range_x)
      end)
    end)
    |> List.flatten
    |> Enum.map(fn(color) -> %PictureProcess.Color{color | status: 0} end)
    |> Enum.reduce({0, %{}}, fn(color, {index, index_color_map}) ->

      {index + 1, Map.put(index_color_map, index, color)}
    end)
  end

  def get_state(color_list) do
    {:ok , changed_colors} = State.start_link()

    Enum.each(color_list, fn({index, color}) ->
      State.put(changed_colors, index, color)
    end)

    changed_colors
  end

  def get_url do
    to_string(image_url())
  end

  def image_url do
    picture_num = :rand.uniform(6) - 1

    IO.puts "HERE #{picture_num}"

    Enum.at(available_urls, picture_num)
  end

  defp available_urls do
    [
      'https://res.cloudinary.com/df0xbva5c/image/upload/v1522958318/6.png',
      'https://res.cloudinary.com/df0xbva5c/image/upload/v1522687912/5.png',
      'https://res.cloudinary.com/df0xbva5c/image/upload/v1522958240/4.png',
      'https://res.cloudinary.com/df0xbva5c/image/upload/v1522957952/3.png',
      'https://res.cloudinary.com/df0xbva5c/image/upload/v1522957233/2.png',
      'https://res.cloudinary.com/df0xbva5c/image/upload/v1522952498/1.png'
    ]
  end
end
