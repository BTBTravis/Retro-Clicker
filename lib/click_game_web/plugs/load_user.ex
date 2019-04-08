defmodule ClickGameWeb.Plugs.LoadUser do
  import Plug.Conn

  alias ClickGame.Accounts.User
  alias ClickGame.Accounts

  @realm "Basic realm=\"API\""

  def init(default), do: default

  def call(conn, _default) do
    case get_req_header(conn, "authorization") do
      ["key " <> key] ->
        load_user(conn, key)
      _ ->
        unauthorized(conn)
    end
  end


  defp load_user(conn, key) do
    case Accounts.get_user_by_api_key(key) do
      %User{} = user -> assign(conn, :user, user)
      _ -> unauthorized(conn)
    end
  end

  defp unauthorized(conn) do
    conn
    |> put_resp_header("www-authenticate", @realm)
    |> send_resp(401, "unauthorized")
    |> halt()
  end
end

