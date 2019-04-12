defmodule ClickGame.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field :clicks, :integer, default: 0
    belongs_to :user, ClickGame.Accounts.User
    has_many :clickers, ClickGame.Games.Clicker


    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:clicks, :user_id])
    |> validate_required([:user_id])
    |> unique_constraint(:user_id)
    # |> foreign_key_constraint(:user_id)
  end
end
