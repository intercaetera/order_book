defmodule OrderBook.Scripts.Simulator do
  @moduledoc """
  For testing (IEx) use only.
  """

  @names ["META", "AAPL", "GOOG", "MSFT", "AMZN", "NFLX"]
  @types [:bid, :ask]

  def simulate(trades \\ 10) do
    Enum.each(@names, fn name -> OrderBook.find_or_create_book(name) end)
    Enum.each(1..trades, fn _ -> simulate_trade() end)
  end

  defp simulate_trade() do
    name = Enum.random(@names)
    type = Enum.random(@types)
    volume = Enum.random(1..40)
    price = Enum.random(1..100) * 10

    Kernel.apply(OrderBook, type, [name, volume, price])
  end
end
