defmodule ClickGameWeb.GameController do
  use ClickGameWeb, :controller

  alias ClickGame.Games
  alias ClickGame.Games.Game

  def clicks(conn, _params) do
    render(conn, "clicks.json", clicks: Games.get_latest_click_count(conn.assigns.user.game.id))
  end

  def click(conn, _params) do
    render(conn, "clicks.json", clicks: Games.single_click(conn.assigns.user.game.id))
  end

  def game_url(conn, _params) do
    render(conn, "game_url.json", url: Games.get_game_url(conn.assigns.user.game.id))
  end

  #def click(conn, %{"side" => side}) do
    #render(conn, "game_url.json", url: Games.get_game_url(conn.assigns.user.game.id))
  #end
end
