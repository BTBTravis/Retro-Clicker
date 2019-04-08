defmodule ClickGameWeb.StoreController do
  use ClickGameWeb, :controller

  alias ClickGame.Games.Store

  def clickers(conn, _params) do
    render(conn, "store_items.json", items: Store.get_clickers())
  end

  def upgrades(conn, _params) do
    render(conn, "store_items.json", items: Store.get_upgrades())
  end

  def store(conn, _params) do
    render(conn, "store.json", Store.get_store())
  end
end
