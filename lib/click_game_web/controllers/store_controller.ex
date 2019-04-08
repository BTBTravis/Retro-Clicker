defmodule ClickGameWeb.StoreController do
  use ClickGameWeb, :controller

  alias ClickGame.Games.Store

  def clickers(conn, _params) do
    render(conn, "store_items.json", items: add_index(Store.get_clickers()))
  end

  def upgrades(conn, _params) do
    render(conn, "store_items.json", items: add_index(Store.get_upgrades()))
  end

  def store(conn, _params) do
    %{:clickers => cs, :upgrades => ups} = Store.get_store()
    render(conn, "store.json", %{:clickers => add_index(cs), :upgrades => add_index(ups)})
  end

  defp add_index(list) do
    list
    |> Enum.map(fn x -> Map.from_struct(x) end)
    |> Enum.reduce([], fn item, acc -> [Map.put(item, :id, length(acc)) | acc] end)
  end
end
