defmodule ClickGameWeb.GameView do
  use ClickGameWeb, :view
  alias ClickGameWeb.GameView

  def render("index.json", %{games: games}) do
    %{data: render_many(games, GameView, "game.json")}
  end

  def render("show.json", %{game: game}) do
    %{data: render_one(game, GameView, "game.json")}
  end

  def render("game_url.json", %{url: url}) do
    %{url: url}
  end

  def render("clicks.json", %{clicks: clicks}) do
    %{clicks: clicks}
  end

  def render("game.json", %{game: game}) do
    %{id: game.id,
      clicks: game.clicks
    }
  end
end
