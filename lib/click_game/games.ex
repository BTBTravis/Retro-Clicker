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

  def get_game(id) do
    Repo.get(Game, id)
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
    list_games()
    |> Enum.map(fn g -> ClickGame.Games.ClickSupervisor.start_click_server(g.id) end)
  end

  def refresh_click_server(game_id) do
    pid = Registry.lookup(Registry.ClickStore, game_id) |> hd |> elem(0)
    ClickGame.Games.ClickServer.refresh(pid)
  end

  def handle_click_server_refresh(state) do
    full_game = get_game_full!(state.game_id)
    %{state | :rate => caculate_click_rate(full_game)}
  end

  def handle_click_server_init(game_id) do
    full_game = get_game_full!(game_id)
    %ClickServerState{:clicks => full_game.clicks, :rate => caculate_click_rate(full_game), :game_id => game_id}
  end

  def create_game(attrs \\ %{}) do
    res = %Game{}
    |> Game.changeset(attrs)
    |> Repo.insert()

    with {:ok, %Game{} = game} <- res do
      ClickGame.Games.ClickSupervisor.start_click_server(game.id)
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

  def add_clicker_to_game(game, %Clicker{} = clicker) do
    c = clicker
        |> Ecto.Changeset.change()
        |> Ecto.Changeset.put_assoc(:game, game)
        |> Repo.insert()

    refresh_click_server(game.id)
    c
  end

  defp caculate_click_rate(game) do
    game.clickers
    |> Enum.map(fn c -> c.base_rate end)
    |> Enum.sum()
  end

  def player_balence(game) do
    debt = Enum.reduce(game.clickers, 0, fn x, acc -> x.price + acc end)
    ClickGame.Games.get_latest_click_count(game.id) - debt
  end

  # iex(39)> pids = Enum.map(games, fn g -> Registry.lookup(Registry.ClickStore, g.id) |> hd |> elem(0) end)
  # iex(39)> pids |> Enum.map(fn pid -> ClickGame.Games.ClickServer.get_clicks(pid) end)

end
