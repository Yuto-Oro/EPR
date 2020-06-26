defmodule Cards do
 def createDeck do
 ["Ace", "Two", "Three"]
 end

 def shuffle(deck) do
  Enum.shuffle(deck)
 end
end
