defmodule ClickGameWeb.SessionController do
  use ClickGameWeb, :controller

  alias ClickGame.Accounts
  alias ClickGame.Accounts.User

  def is_logged(conn) do
    get_session(conn, :user_id) !== nil
  end

  def new(conn, _) do
    case get_session(conn, :user_id) do
      nil -> render(conn, "new.html")
      _ -> 
        conn
        |> redirect(to: "/")
    end
  end

  def create(conn, %{"user" => %{"name" => name, "pw" => pw}}) do
    case Accounts.auth_by_pw(name, pw) do
      %User{} = user ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> redirect(to: "/")
      _ -> 
        conn
        |> put_flash(:error, "Bad name/password combination")
        |> redirect(to: Routes.session_path(conn, :new))
    end
  end

  def delete(conn, _) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end
end
