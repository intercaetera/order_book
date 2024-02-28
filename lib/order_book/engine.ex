defmodule OrderBook.Engine do
  @type book :: %{
          name: atom(),
          bids: list(number()),
          asks: list(number()),
          ticker: number()
        }

  @spec new_book(atom()) :: book()
  def new_book(name) do
    %{name: name, bids: [], asks: [], ticker: 0}
  end

  @spec clear(book()) :: book()
  def clear(%{asks: asks, bids: bids} = book) when hd(bids) > hd(asks) do
    [ticker | new_asks] = asks
    [_ | new_bids] = bids
    clear(%{book | asks: new_asks, bids: new_bids, ticker: ticker})
  end

  def clear(book), do: book

  @spec add_bid(book(), number(), number()) :: book()
  def add_bid(%{bids: bids} = book, volume, price) do
    new_bids =
      List.duplicate(price, volume)
      |> Kernel.++(bids)
      |> Enum.sort(:desc)

    Map.put(book, :bids, new_bids) |> clear()
  end

  @spec add_ask(book(), number(), number()) :: book()
  def add_ask(%{asks: asks} = book, volume, price) do
    new_asks =
      List.duplicate(price, volume)
      |> Kernel.++(asks)
      |> Enum.sort(:asc)

    Map.put(book, :asks, new_asks) |> clear()
  end
end
