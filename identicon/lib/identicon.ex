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
    
  end

end
