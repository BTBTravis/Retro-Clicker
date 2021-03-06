defmodule ClickGameWeb.StoreView do
  use ClickGameWeb, :view
  alias ClickGameWeb.StoreView

  def render("store.json", %{clickers: clickers, upgrades: upgrades}) do
    %{:data => %{
      :clickers => render_many(clickers, StoreView, "store_item.json", as: :item),
      :upgrades => render_many(upgrades, StoreView, "store_item.json", as: :item)
    }}
  end

  def render("store_items.json", %{items: items}) do
    %{data: render_many(items, StoreView, "store_item.json", as: :item)}
  end

  def render("store_item.json", %{item: item}) do
    %{
      name: item.name,
      description: item.description,
      sku: item.sku,
      price: item.price,
      rate: item.base_rate
    }
  end

  def render("problem.json", %{reason: reason}) do
    %{
      reason: reason,
    }
  end
end
