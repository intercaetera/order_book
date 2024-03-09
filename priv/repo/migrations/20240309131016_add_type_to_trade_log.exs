defmodule OrderBook.Repo.Migrations.AddTypeToTradeLog do
  use Ecto.Migration

  def change do
    alter table(:trade_logs) do
      add :type, :string, null: false
    end
  end
end
