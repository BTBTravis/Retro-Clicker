defmodule ClickGameWeb.PageController do
  use ClickGameWeb, :controller
  alias ClickGame.Games

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def game(conn, %{"id" => id}) do
    case Games.get_game(id) do
      %Games.Game{} = game -> render(conn, "game.html", game: game)
      _ -> 
        conn
        |> put_status(:not_found)
        |> put_view(ClickGameWeb.ErrorView)
        |> render("404.html")
    end
  end
  
end
