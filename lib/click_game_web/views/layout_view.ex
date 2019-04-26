defmodule ClickGameWeb.LayoutView do
  use ClickGameWeb, :view

  def is_logged(conn) do
    ClickGameWeb.SessionController.is_logged(conn)
  end

  def js_files(conn) do
    conn.assigns[:js_files] || []
  end
end
