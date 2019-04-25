defmodule ClickGame.Games.Clicker do
  use Ecto.Schema
  import Ecto.Changeset

  @type_normal "normal"
  def normal, do: @type_normal

  schema "clickers" do
    belongs_to :game, ClickGame.Games.Game

    field :name, :string
    field :description, :string
    field :base_rate, :integer, default: 0
    field :type, :string
    field :sku, :string
    field :price, :integer

    timestamps()
  end

  @doc false
  def changeset(clicker, attrs) do
    clicker
    |> cast(attrs, [:game_id, :name, :description, :base_rat, :type, :sku, :price])
    |> validate_required([:game_id, :name, :description, :base_rat, :type, :sku, :price])
  end
end
