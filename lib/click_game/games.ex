defmodule ClickGame.Games do
  @moduledoc """
  The Games context.
  """
  import Ecto.Query, warn: false
  alias ClickGame.Repo
  alias ClickGame.Games.Game
  alias ClickGame.Games.ClickServerState

  @doc """
  Gets a single game.
  """
  def get_game!(id), do: Repo.get!(Game, id)

  @doc """
  List all games
  """
  def list_games do
    Repo.all(Game)
  end

  @doc """
  Start click servers for all games
  """
  def start_click_servers() do
    list_games()
    |> Enum.map(fn g -> ClickGame.Games.ClickSupervisor.start_click_server(g.id, %ClickServerState{:clicks => g.clicks, :rate => caculate_click_rate(g), :game_id => g.id}) end)
  end

  @doc """
  Creates a game given a change set
  """
  def create_game(attrs \\ %{}) do
    res = %Game{}
    |> Game.changeset(attrs)
    |> Repo.insert()

    with {:ok, %Game{} = game} <- res do
      ClickGame.Games.ClickSupervisor.start_click_server(game.id, %ClickServerState{:clicks => game.clicks, :rate => caculate_click_rate(game), :game_id => game.id})
      game.id
    end
    res
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

  defp caculate_click_rate(_game) do
    0
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
