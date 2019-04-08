defmodule ClickGameWeb.StoreController do
  use ClickGameWeb, :controller

  alias ClickGame.Games.Store

  def clickers(conn, _params) do
    render(conn, "clickers.json", clickers: Store.get_clickers())
  end
end
