defmodule ClickGame.Games do
  @moduledoc """
  The Games context.
  """

  import Ecto.Query, warn: false
  alias ClickGame.Repo

  alias ClickGame.Games.Game


  @doc """
  Gets a single game.
  """
  def get_game!(id), do: Repo.get!(Game, id)

  @doc """
  Creates a game.

  ## Examples

  iex> ClickGame.Games.create_game(%{:user_id => 1}) 
      {:ok, %Game{}}

      iex> create_game(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_game(attrs \\ %{}) do
    %Game{}
    |> Game.changeset(attrs)
    |> Repo.insert()
  end



  @doc """
  Returns the URL the player may view their game at
  """
  def get_game_url(game_id) do
    "http://clickgame.travisshears.xyz/game/" <> Integer.to_string(game_id)
  end
end
