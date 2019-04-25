defmodule ClickGameWeb.GameStateView do
  use ClickGameWeb, :view
  alias ClickGameWeb.GameStateView

  def render("state.json", %{clickers: clickers}) do
    %{:data => %{
      :store => %{
        :clickers => render_many(clickers, ClickGameWeb.StoreView, "store_item.json", as: :item),
      }
    }}
  end
end
