defmodule ClickGameWeb.GameStateView do
  use ClickGameWeb, :view
  alias ClickGameWeb.GameStateView

  def render("state.json", %{
    store_clickers: store_clickers,
    clickers: clickers
  }) do
    %{:data => %{
      :clickers => render_many(clickers, ClickGameWeb.StoreView, "store_item.json", as: :item),
      :store => %{
        :clickers => render_many(store_clickers, ClickGameWeb.StoreView, "store_item.json", as: :item),
      }
    }}
  end
end
