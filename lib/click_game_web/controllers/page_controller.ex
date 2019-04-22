defmodule ClickGameWeb.PageController do
  use ClickGameWeb, :controller
  alias ClickGame.Games

  def index(conn, _params) do
    render(conn, "index.html", game_url: game_url(conn))
  end

  defp game_url(conn) do
    case conn.assigns[:user] do
      %ClickGame.Accounts.User{} = user -> Routes.game_path(conn, :view, user.game.id)
      _ -> ""
    end
  end
end
