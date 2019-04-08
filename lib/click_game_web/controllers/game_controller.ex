defmodule ClickGameWeb.GameController do
  use ClickGameWeb, :controller

  alias ClickGame.Games
  alias ClickGame.Games.Game

  def game_url(conn, _params) do
    render(conn, "game_url.json", url: Games.get_game_url(conn.assigns.user.game.id))
  end

  def click(conn, %{"side" => side}) do
    render(conn, "game_url.json", url: Games.get_game_url(conn.assigns.user.game.id))
  end
end
