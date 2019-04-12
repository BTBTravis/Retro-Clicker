defmodule ClickGame.Games.Store do
  @moduledoc """
  CLickGames' store where different clickers and upgrades
  """
  alias ClickGame.Games.Clicker
  alias ClickGame.Games.Upgrade

  @upgrades [
    %Upgrade{name: "Double Click", type_change: :none, active: false, additional_rate: 1, price: 1000},
    %Upgrade{name: "Tripple Click", type_change: :none, active: false, additional_rate: 2, price: 1000}
  ]

  @clickers [
    %Clicker{name: "Left Clicker", type: Clicker.left, is_active: false, base_rate: 1, price: 10},
    %Clicker{name: "Right Clicker", type: Clicker.right, is_active: false, base_rate: 1, price: 10},
    %Clicker{name: "Simul Clicker", type: Clicker.both, is_active: false, base_rate: 1, price: 1000}
  ]

  def get_clickers() do
    @clickers
  end

  def get_upgrades() do
    @upgrades
  end
  
  def get_store() do
    %{:clickers => @clickers, :upgrades => @upgrades}
  end
end
