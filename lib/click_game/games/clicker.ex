defmodule ClickGame.Games.Clicker do
  @enforce_keys [:name, :type, :active, :base_rate, :price]
  defstruct name: "Left Clicker", type: :left, active: false, base_rate: 1, price: 10
end
