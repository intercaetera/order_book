defmodule OrderBook.EngineTest do
  use ExUnit.Case

  import OrderBook.Engine

  test "new_book creates a new order book with ticker value of 0" do
    assert %{name: "TEST", ticker: 0} = new_book("TEST") 
  end

  test "add_bid adds new bids sorted descending" do
    book = %{name: "TEST", bids: [30, 10], asks: [], ticker: 0}
    %{bids: bids} = add_bid(book, 2, 20)
    assert bids == [30, 20, 20, 10]
  end

  test "add_ask adds new bids sorted ascending" do
    book = %{name: "TEST", bids: [], asks: [50, 70], ticker: 0}
    %{asks: asks} = add_ask(book, 2, 60)
    assert asks == [50, 60, 60, 70]
  end

  test "clear removes entries when highest bid is larger than lowest ask" do
    book = %{name: "TEST", bids: [50, 60], asks: [10, 20], ticker: 0}
    %{asks: asks, bids: bids} = clear(book)

    assert asks == []
    assert bids == []
  end

  test "clear updates ticker to value of lowest ask when an entry is cleared" do
    book = %{name: "TEST", bids: [50], asks: [40], ticker: 0}
    %{ticker: ticker} = clear(book)

    assert ticker == 40
  end
end
