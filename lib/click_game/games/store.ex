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
    %Clicker{
      name: "Left Clicker", 
      description: "Normal Left clicker that clicks blue at 1 click/sec",
      type: Clicker.left,
      is_active: false,
      base_rate: 1,
      price: 10
    },
    %Clicker{
      name: "Right Clicker",
      description: "Normal Right clicker that clicks red at 1 click/sec",
      type: Clicker.right,
      is_active: false,
      base_rate: 1,
      price: 10
    },
    %Clicker{name: "Simul Clicker",
      type: Clicker.both,
      description: "Special clicker clicks both buttons at a rate of 1 click/sec",
      is_active: false,
      base_rate: 1,
      price: 1000
    }
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

  def buy_clicker(index, _instant_activate, game_id) do
    #{:ok, %ClickGame.Games.Game{} = game} = ClickGame.Games.get_game!(game_id)
    game = ClickGame.Games.get_game_full!(game_id)
    clicker = Enum.at(@clickers, String.to_integer(index), :none)
    can_afford = case clicker do
      :none -> false
      %Clicker{} = c -> c.price <= player_balence(game)
      _ -> false
    end

    cond do
      not can_afford -> {:error, "you can't afford that clicker yet"}
      true -> ClickGame.Games.add_clicker_to_game(game, clicker)
    end
  end

  def player_balence(game) do
    debt = Enum.reduce(game.clickers, 0, fn x, acc -> x.price + acc end)
    ClickGame.Games.get_latest_click_count(game.id) - debt
  end
end
