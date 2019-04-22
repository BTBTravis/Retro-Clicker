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
    case Games.get_game(id) do
      %Games.Game{} = game -> render(conn, "show.html", game: game)
      _ -> 
        conn
        |> put_status(:not_found)
        |> put_view(ClickGameWeb.ErrorView)
        |> render("404.html")
    end
  end
end
