defmodule Identicon do
  @moduledoc """
  Documentation for Identicon.
  """

  @image_width 250
  @image_height 250
  @square_width 50
  @square_height 50
  @squares_per_row 5
  @squares_per_column 5

  @doc """
  Turns `input` into an image and saves it on the harddisk

  """
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  @doc """
  Turns `input` into the md5-hash and returns it as a list

  ## Examples

      iex> Identicon.hash_input "Elixir"
      %Identicon.Image{
        hex: [161, 46, 176, 98, 236, 169, 209, 230, 198, 159, 207, 139, 96, 55, 135, 195]
      }

  """
  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list
    %Identicon.Image{hex: hex}
  end

  def pick_color(%Identicon.Image{hex: [r, g, b | _rest]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  def build_grid(%Identicon.Image{hex: hexlist} = image) do
    grid = hexlist
    |> Enum.chunk_every(3)
    |> Enum.map(&mirror_row/1)
    |> List.flatten
    |> Enum.with_index
    %Identicon.Image{image | grid: grid}
  end

  def mirror_row([one, two, three]) do
    [one, two, three, two, one]
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid =
      Enum.filter grid, fn({x, _index}) ->
        rem(x, 2) == 0
    end

    %Identicon.Image{image | grid: grid}
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map =
      Enum.map grid, fn({_code, index}) ->
        horizontal = rem(index, @squares_per_row) * @square_width
        vertical = div(index, @squares_per_column) * @square_height

        top_left = {horizontal, vertical}
        bottom_right = {horizontal + @square_width, vertical + @square_height}

        {top_left, bottom_right}
    end

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(@image_width, @image_height)
    fill = :egd.color(color)
    Enum.each pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
  end

  def save_image(image, filename) do
    File.write("#{filename}.png", image)
  end
end
