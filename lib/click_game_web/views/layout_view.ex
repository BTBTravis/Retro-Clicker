defmodule ClickGameWeb.LayoutView do
  use ClickGameWeb, :view

  def is_logged(conn) do
    ClickGameWeb.SessionController.is_logged(conn)
  end
end
