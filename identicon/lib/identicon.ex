defmodule Identicon do
  @moduledoc """
  Documentation for `Identicon`.
  """

  def main(input) do
    input
    |> hashInput
    |> pickColor
    |> buildGrid
    |> filterOddEven
    |> buildPixelMap
    |> drawImage
    |> saveImage(input)
  end

  @doc """
    Function that returns md5 hash of our input.
  """
  def hashInput(input) do
    hex = :crypto.hash(:md5,input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end

  @doc """
  Function that uses pattern matching to obtain the RGB color from our hash,
  then updates our map property from our struct.
  """
  def pickColor(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  @doc """
  Function that creates the Grid with help of `mirrorRow` function.
  """
  def buildGrid(%Identicon.Image{hex: hex} = image) do
    grid = 
      hex
      |> Enum.chunk(3)
      |> Enum.map(&mirrorRow/1) #Pasamos la referencia de nuestra función.
      |> List.flatten #Nos quita el problema de una lista anidada (lista de listas).
      |> Enum.with_index #Toma nuestra lista y la indexa

    %Identicon.Image{image | grid: grid}
  end

  @doc """
  Mirrors the fist two elements that are sent from `buildGrid` function and returns it.
  """
  def mirrorRow(row) do
    [first, second | _tail ] = row
    row ++ [second, first]
  end

  @doc """
  Function that will return a list of even numbers to color our grid.
  """
  def filterOddEven(%Identicon.Image{grid: grid} = image) do
    grid = Enum.filter grid, fn({code, _index}) -> 
      rem(code,2) == 0
    end
    %Identicon.Image{image | grid: grid}
  end

  def buildPixelMap(%Identicon.Image{grid: grid} = image) do
    pixelMap = Enum.map grid, fn({_code, index}) ->
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50
      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}

      {top_left, bottom_right}
    end

    %Identicon.Image{image | pixelMap: pixelMap}
  end

  def drawImage(%Identicon.Image{color: color, pixelMap: pixelMap}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)
    
    Enum.each pixelMap, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
  end

  def saveImage(image, input) do
    File.write("#{input}.png", image)
  end

end
