defmodule ClickGameWeb.Router do
  use ClickGameWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :player_api do
    plug :accepts, ["json"]
    plug ClickGameWeb.Plugs.LoadUser
  end

  pipeline :admin_api do
    plug :accepts, ["json"]
  end

  scope "/", ClickGameWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/games", GameController
  end

  # Other scopes may use custom stacks.
  scope "/api/admin/", ClickGameWeb do
    pipe_through :admin_api
    resources "/users", UserController, except: [:new, :edit]
  end

  scope "/api/player/", ClickGameWeb do
    pipe_through :player_api
    get "/game_url", GameController, :game_url
    # get "/click/:side", GameController, :click
    get "/store/clickers", StoreController, :clickers
    # resources "/game", UserController, :game
  end
end
