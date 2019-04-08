defmodule ClickGame.Games.Upgrade do
  @enforce_keys [:name, :type_change, :active,  :additional_rate, :price]
  defstruct name: "Double Click", 
    type_change: :left, 
    active: false, 
    additional_rate: 1, 
    price: 10
end
