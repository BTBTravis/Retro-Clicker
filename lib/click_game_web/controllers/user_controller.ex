defmodule ClickGameWeb.UserController do
  use ClickGameWeb, :controller

  alias ClickGame.Accounts
  alias ClickGame.Accounts.User

  action_fallback ClickGameWeb.FallbackController

  def new(conn, _params) do
    cond do
      ClickGameWeb.SessionController.is_logged(conn) ->
        conn
        |> redirect(to: "/")
      true -> render(conn, "new.html")
    end
  end

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => %{"name" => name, "pw" => pw}}) do
    case Accounts.create_user_and_game(%{"name" => name, "pw" => pw}) do
      {:ok, %User{} = user} ->
        ClickGameWeb.SessionController.create(conn, 
          %{"user" => 
            %{
              "name" => user.name, 
              "pw" => pw
            }
          })
      _ -> 
        conn
        |> put_flash(:error, "Bad name/password combination")
        |> redirect(to: Routes.user_path(conn, :new))
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
