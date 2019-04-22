defmodule ClickGameWeb.Router do
  use ClickGameWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  #pipeline :player_api do
    #plug :accepts, ["json"]
    #plug ClickGameWeb.Plugs.LoadUser
  #end

  #pipeline :admin_api do
    #plug :accepts, ["json"]
  #end

  pipeline :user_loader do
    plug ClickGameWeb.Plugs.LoadUser
    plug :put_socket_token
  end

  defp put_socket_token(conn, _) do
    if current_user = conn.assigns[:user] do
      token = Phoenix.Token.sign(conn, "user socket", current_user.id)
      assign(conn, :user_token, token)
    else
      conn
    end
  end

  scope "/", ClickGameWeb do
    pipe_through :browser
    pipe_through :user_loader

    get "/", PageController, :index
    get "/login", SessionController, :new
    get "/signup", UserController, :new
    resources "/sessions", SessionController, only: [:create, :delete], singleton: true
    resources "/users", UserController, only: [:create, :delete], singleton: true
    get "/game/:id", GameController, :view
  end

  # Other scopes may use custom stacks.
  #scope "/api/admin/", ClickGameWeb do
    #pipe_through :admin_api
    ##resources "/users", UserController, except: [:new, :edit]
  #end

  #scope "/api/player/", ClickGameWeb do
    #pipe_through :player_api
    #get "/game_url", GameController, :game_url
    #get "/clicks", GameController, :clicks
    #get "/click", GameController, :click
    ## get "/click/:side", GameController, :click
    #get "/store/clickers", StoreController, :clickers
    #get "/store/upgrades", StoreController, :upgrades
    #get "/store", StoreController, :store
    #get "/store/clickers/buy/:id", StoreController, :buy_clicker
    ## resources "/game", UserController, :game
  #end
end
