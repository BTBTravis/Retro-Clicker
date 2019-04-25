defmodule ClickGame.Repo.Migrations.CreateClickers do
  use Ecto.Migration

  def change do
    create table(:clickers) do
      add :name, :string
      add :description, :string
      add :base_rate, :integer, default: 0
      add :game_id, references(:games, on_delete: :delete_all), null: false
      add :type, :string
      add :sku, :string
      add :price, :integer

      timestamps()
    end

  end
end
