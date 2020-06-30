defmodule Cards do
@moduledoc """
   Métodos para crear y repartir un mazo de cartas.
"""

@doc """
   Regresa una lista de strings representando un mazo de cartas para jugar.
"""
 def createDeck do
    values = ["Ace", "Two", "Three", "four", "five"]
    suits = ["Spades", "Clubs", "Hearts", "Diamonds"]
    
    for suit <- suits,value <- values do
        "#{value} of #{suit}"
    end
    
 end

 def shuffle(deck) do
    Enum.shuffle(deck)
 end

@doc """
   Determina si un mazo contiene una carta.

   ## Examples

        iex(1)> deck = Cards.createDeck
        iex(2)> Cards.contains?(deck, "Ace of Spades")
        true 
"""
 def contains?(deck, card) do
    Enum.member?(deck, card)
 end

@doc """
   Divide el mazo en una mano.
   El argumento `handSize` nos indica cuantas cartas deberian estar en la mano.

   ## Examples

         iex> deck = Cards.createDeck
         iex> {hand, deck} = Cards.deal(deck, 1)
         iex> hand
         ["Ace of Spades"]
"""
 def deal(deck, handSize) do
 #Nos regresa una tupla que en el index 0 tendrá lo que pedimos.
    Enum.split(deck, handSize)
 end

#Modulo para guardar el archivo en el sistema.
 def save(deck, fileName) do
     binary = :erlang.term_to_binary(deck)
     File.write(fileName, binary)
 end

#Modulo para cargar datos desde el disco
 def load(fileName) do
    case File.read(fileName) do #Pattern Matching con la tupla en el case
    #Comparamos el resultado de File.read() y lo asignamos dependiendo si es error o no a la variable.
        {:ok, binary} -> :erlang.binary_to_term binary
        {:error, _reason} -> "El archivo no existe" # _ Se usa para ignorar una variable
    end
 end
#Modulo que concatena los otros módulos con ' | '
 def createHand(handSize) do
    Cards.createDeck #Toma el return value y lo va pasando
    |> Cards.shuffle
    |> Cards.deal(handSize)
 end
end
