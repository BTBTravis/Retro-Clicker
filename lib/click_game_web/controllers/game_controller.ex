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

  def view(conn, %{"id" => id}) do
    game_url = case conn.assigns.user.game.id do
      nil -> ""
      id -> Routes.game_path(conn, :view) <> id
    end
    render(conn, "index.html", game_url: game_url)
  end
end
