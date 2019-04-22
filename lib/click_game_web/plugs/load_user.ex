defmodule ClickGameWeb.Plugs.LoadUser do
  import Plug.Conn

  alias ClickGame.Accounts.User
  alias ClickGame.Accounts

  @realm "Basic realm=\"Browser\""

  def init(default), do: default

  def call(conn, _default) do
    user_id = get_session(conn, :user_id)
    cond do
      user_id !== nil -> load_user(conn, user_id)
      true -> conn
    end

  end

  defp load_user(conn, id) do
    case Accounts.get_user!(id) do
      %User{} = user -> assign(conn, :user, user)
      _ -> conn
    end
  end
end

