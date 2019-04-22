defmodule ClickGameWeb.PageView do
  use ClickGameWeb, :view

  def is_logged(conn) do
    ClickGameWeb.LayoutView.is_logged(conn)
  end
end
