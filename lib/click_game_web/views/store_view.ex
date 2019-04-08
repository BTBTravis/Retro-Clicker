defmodule ClickGameWeb.StoreView do
  use ClickGameWeb, :view
  alias ClickGameWeb.StoreView

  #def render("index.json", %{games: games}) do
    #%{data: render_many(games, GameView, "game.json")}
  #end

  def render("clickers.json", %{clickers: clickers}) do
    %{data: render_many(clickers, StoreView, "clicker.json", as: :clicker)}
  end

  def render("clicker.json", %{clicker: clicker}) do
    %{ 
      name: clicker.name, 
      type: clicker.type, 
      base_rate: clicker.base_rate, 
      price: clicker.price
    }
  end
end
