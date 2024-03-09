defmodule OrderBook.Repo.Migrations.CreateTradeLog do
  use Ecto.Migration

  def change do
    create table(:trade_logs) do
      add :name, :string, null: false
      add :volume, :integer, null: false
      add :price, :integer, null: false

      timestamps()
    end
  end
end
