defmodule Cards do
 def createDeck do
    values = ["Ace", "Two", "Three", "four", "five"]
    suits = ["spades", "clubs", "hearts", "diamons"]
    
    for suit <- suits,value <- values do
        "#{value} of #{suit}"
    end
    
 end

 def shuffle(deck) do
    Enum.shuffle(deck)
 end

 def contains?(deck, card) do
    Enum.member?(deck, card)
 end

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
