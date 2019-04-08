defmodule ClickGame.Games.Store do
  @moduledoc """
  CLickGames' store where different clickers and upgrades
  """
  alias ClickGame.Games.Game
  alias ClickGame.Games.Clicker

  @clickers [
    %Clicker{name: "Left Clicker", type: :left, active: false, base_rate: 1, price: 100},
    %Clicker{name: "Right Clicker", type: :right, active: false, base_rate: 1, price: 100}
  ]

  @doc """
  Gets a single game.
  """
  def get_clickers() do
    @clickers
  end

end
