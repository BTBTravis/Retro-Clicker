defmodule ClickGameWeb.Router do
  use ClickGameWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ClickGameWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/games", GameController
  end

  # Other scopes may use custom stacks.
  scope "/api/admin/", ClickGameWeb do
    pipe_through :api
    resources "/users", UserController, except: [:new, :edit]
  end
end
