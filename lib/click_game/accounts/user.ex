defmodule ClickGame.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :apikey, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :apikey])
    |> validate_required([:name, :apikey])
  end
end
