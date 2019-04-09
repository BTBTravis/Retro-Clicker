defmodule ClickGameWeb.UserController do
  use ClickGameWeb, :controller

  alias ClickGame.Accounts
  alias ClickGame.Accounts.User

  action_fallback ClickGameWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"name" => name, "clicks" => clicks}) do
    with {:ok, user} <- Accounts.create_user(%{"name" => name}) do
      ClickGame.Games.create_game(%{:user_id => user.id, :clicks => clicks})

      loaded_user = Accounts.get_user!(user.id)

      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, loaded_user))
      |> render("show.json", user: loaded_user)
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