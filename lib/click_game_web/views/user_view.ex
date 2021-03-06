defmodule ClickGameWeb.UserView do
  use ClickGameWeb, :view
  alias ClickGameWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      name: user.name,
      apikey: user.apikey,
      game: render_one(user.game, ClickGameWeb.GameView, "game.json")
    }
  end

end
