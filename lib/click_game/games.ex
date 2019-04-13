defmodule ClickGame.Games do
  @moduledoc """
  The Games context.
  """
  import Ecto.Query, warn: false
  alias ClickGame.Repo
  alias ClickGame.Games.Game
  alias ClickGame.Games.ClickServerState
  alias ClickGame.Games.Clicker


  def get_game!(id) do
    Repo.get!(Game, id)
  end

  def get_game_full!(id) do
    Repo.get!(Game, id)
    |> Repo.preload(:clickers)
  end

  def list_games do
    Repo.all(Game)
  end

  def list_games_full do
    Repo.all(Game)
    |> Repo.preload(:clickers)
  end

  def start_click_servers() do
    list_games_full()
    |> Enum.map(fn g -> ClickGame.Games.ClickSupervisor.start_click_server(g.id, %ClickServerState{:clicks => g.clicks, :rate => caculate_click_rate(g), :game_id => g.id}) end)
  end

  def update_clicker_server_rate(game_id, rate) do
    pid = Registry.lookup(Registry.ClickStore, game_id) |> hd |> elem(0)
    ClickGame.Games.ClickServer.update_rate(pid, rate)
    #case ClickGame.Games.ClickServer.update_rate(pid, rate) do
      #{:ok, _rate} -> {:ok, "updated rate"}
      #{:error, _e} -> {:error, "could not updated rate"}
    #end
  end

  def create_game(attrs \\ %{}) do
    res = %Game{}
    |> Game.changeset(attrs)
    |> Repo.insert()

    with {:ok, %Game{} = game} <- res,
         {:ok,  %Game{} = full_game} <- get_game_full!(game.id) do 
      ClickGame.Games.ClickSupervisor.start_click_server(
        game.id, 
        %ClickServerState{:clicks => game.clicks, :rate => caculate_click_rate(full_game), :game_id => game.id}
      )
      end
    end

  @doc """
  Get the current number of clicks from the click server
  """
  def get_latest_click_count(game_id) do
    pid = Registry.lookup(Registry.ClickStore, game_id) |> hd |> elem(0)
    ClickGame.Games.ClickServer.get_clicks(pid)
  end

  def single_click(game_id) do
    pid = Registry.lookup(Registry.ClickStore, game_id) |> hd |> elem(0)
    ClickGame.Games.ClickServer.click(pid)
  end

  def sync_clicks(game_id, clicks) do
    game = get_game!(game_id)
    update_game(game, %{:clicks => clicks})
  end

  def update_game(%Game{} = game, attrs) do
    game
    |> Game.changeset(attrs)
    |> Repo.update()
  end

  def add_clicker_to_game(game, %Clicker{} = clicker) do
    clicker
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:game, game)
    |> Repo.insert()
  end

  defp caculate_click_rate(game) do
    game.clickers
    |> Enum.map(fn c -> c.base_rate end)
    |> Enum.sum()
  end

  # iex(39)> pids = Enum.map(games, fn g -> Registry.lookup(Registry.ClickStore, g.id) |> hd |> elem(0) end)
  # iex(39)> pids |> Enum.map(fn pid -> ClickGame.Games.ClickServer.get_clicks(pid) end)

  @doc """
  Returns the URL the player may view their game at
  """
  def get_game_url(game_id) do
    Application.get_env(:click_game, ClickGameWeb.Endpoint)[:url][:host] <> "/" <> Integer.to_string(game_id)
  end
end
