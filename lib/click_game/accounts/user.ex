defmodule ClickGame.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :apikey, :string
    field :name, :string
    field :password_hash, :string
    has_one :game, ClickGame.Games.Game

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:apikey, :name, :password_hash])
    |> validate_required([:apikey, :name, :password_hash])
    |> unique_constraint(:name)
  end
end
