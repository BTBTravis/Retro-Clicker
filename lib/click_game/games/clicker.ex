defmodule ClickGame.Games.Clicker do
  use Ecto.Schema
  import Ecto.Changeset

  @type_left "left"
  def left, do: @type_left
  @type_right "right"
  def right, do: @type_right
  @type_both "both"
  def both, do: @type_both

  schema "clickers" do
    belongs_to :game, ClickGame.Games.Game

    field :name, :string
    field :description, :string
    field :base_rate, :integer, default: 0
    field :is_active, :boolean, default: false
    field :price, :integer
    field :type, :string


    timestamps()
  end

  @doc false
  def changeset(clicker, attrs) do
    clicker
    |> cast(attrs, [:game_id, :name, :description, :base_rate, :price, :is_active])
    |> validate_required([:game_id, :name, :description, :base_rate, :price, :is_active])
  end
end
