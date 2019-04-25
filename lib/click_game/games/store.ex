defmodule ClickGame.Games.Store do
  @moduledoc """
  CLickGames' store where different clickers and upgrades
  """
  alias ClickGame.Games.Clicker

  def clicker_pairs() do
    [
      { &(Kernel.trunc(Float.ceil(15 * :math.pow(1.159, &1)))),
        %Clicker{
          name: "Classic Trackball Clicker", 
          description: "Back to the good old days",
          base_rate: 1,
          type: Clicker.normal,
          sku: "C001",
        }
      },
      { &(Kernel.trunc(Float.ceil(600 * :math.pow(1.156, &1)))),
        %Clicker{
          name: "Red Lazer Clicker",
          description: "Just don't use it on glass",
          base_rate: 4,
          type: Clicker.normal,
          sku: "C002",
        }
      },
      { &(Kernel.trunc(Float.ceil(1500 * :math.pow(1.153, &1)))),
        %Clicker{
          name: "Orbital (K64327F) Clicker",
          description: "Out of this world",
          base_rate: 10,
          type: Clicker.normal,
          sku: "C003",
        }
      }
    ]
  end

  @spec get_clickers([%Clicker{}]) :: [%Clicker{}]
  def get_clickers(clickers) do
    counts = Enum.reduce(clickers, %{}, fn x, acc ->
      sku = x.sku
      cond do
        Map.has_key?(acc, sku) -> 
         Map.get_and_update(acc, sku, fn total ->
          {total, total + 1}
         end) 
        true -> Map.put(acc, sku, 1)
      end
    end)

    clicker_pairs()
    |> Enum.map(fn x -> 
      clicker = elem(x, 1)
      sku = clicker.sku
      priceFn = elem(x, 0)
      cond do 
        Map.has_key?(counts, sku) -> 
          Map.update!(clicker, :price, fn _ -> priceFn.(counts[sku]) end)
        true -> 
          Map.update(clicker, :price, 0, fn _ -> priceFn.(0) end)
      end
    end)
  end

  #def buy_clicker(index, _instant_activate, game_id) do
    ##{:ok, %ClickGame.Games.Game{} = game} = ClickGame.Games.get_game!(game_id)
    #game = ClickGame.Games.get_game_full!(game_id)
    #clicker = Enum.at(@clickers, String.to_integer(index), :none)
    #can_afford = case clicker do
      #:none -> false
      #%Clicker{} = c -> c.price <= player_balence(game)
      #_ -> false
    #end

    #cond do
      #not can_afford -> {:error, "you can't afford that clicker yet"}
      #true -> ClickGame.Games.add_clicker_to_game(game, clicker)
    #end
  #end

  #def player_balence(game) do
    #debt = Enum.reduce(game.clickers, 0, fn x, acc -> x.price + acc end)
    #ClickGame.Games.get_latest_click_count(game.id) - debt
  #end
end
