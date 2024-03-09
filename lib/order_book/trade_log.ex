defmodule OrderBook.TradeLog do
  use Ecto.Schema
  alias OrderBook.Repo
  import Ecto.Changeset

  schema "trade_logs" do
    field :name, :string
    field :volume, :integer
    field :price, :integer
    field :type, Ecto.Enum, values: [:bid, :ask]

    timestamps()
  end

  def changeset(trade_log, params \\ %{}) do
    trade_log
    |> cast(params, [:name, :type, :volume, :price])
    |> validate_required([:name, :type, :volume, :price])
    |> validate_number(:volume, greater_than: 0)
    |> validate_number(:price, greater_than: 0)
  end

  def create_log(name, type, volume, price) do
    changeset(%__MODULE__{}, %{name: name, type: type, volume: volume, price: price})
    |> Repo.insert()
  end

  def get_all_logs() do
    Repo.all(__MODULE__)
  end
end
