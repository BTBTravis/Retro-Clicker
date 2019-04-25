defmodule ClickGame.Games.Store do
  @moduledoc """
  CLickGames' store where different clickers and upgrades
  """
  alias ClickGame.Games.Clicker
  alias ClickGame.Games

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
    counts = clickers
	     |> Enum.map(&(&1.sku))
	     |> Enum.reduce(%{}, fn x, acc ->
	       count = Map.get(acc, x, 0)
	       Map.put(acc, x, count + 1)
	     end)

    clicker_pairs()
    |> Enum.map(fn x -> 
      priceFn = elem(x, 0)
      clicker = elem(x, 1)
      sku = clicker.sku
      count = counts[sku] || 0
      %Clicker{ clicker | price: priceFn.(count) }
    end)
  end

  def buy_clicker(sku, game_id) do
    game = ClickGame.Games.get_game_full!(game_id)
    {priceFn, clicker} = Enum.reduce(
      clicker_pairs(), 
      hd(clicker_pairs()), 
      fn x, acc -> c = elem(x,1)
        c_sku = c.sku
        cond do
          c_sku == sku -> x
          true -> acc
        end
      end
    )
    existing_count = game.clickers
		     |> Enum.filter(&(&1.sku == sku))
		     |> Enum.count
    price = priceFn.(existing_count)
    can_afford = price <= Games.player_balence(game)
    final_clicker = %Clicker{clicker | price: price}

    cond do
      not can_afford -> {:error, "you can't afford that clicker yet"}
      true -> Games.add_clicker_to_game(game, final_clicker)
    end
  end
end
