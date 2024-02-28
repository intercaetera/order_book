defmodule OrderBook.BookServer do
  use GenServer

  alias OrderBook.Engine

  def bid(pid, volume, price) do
    GenServer.cast(pid, {:bid, volume, price})
  end

  def ask(pid, volume, price) do
    GenServer.cast(pid, {:ask, volume, price})
  end

  def status(pid) do
    GenServer.call(pid, :status)
  end

  @impl true
  def init(name) do
    initial_state = Engine.new_book(name)
    {:ok, initial_state}
  end

  @impl true
  def handle_cast({:bid, volume, price}, state) do
    {:noreply, Engine.add_bid(state, volume, price)}
  end

  @impl true
  def handle_cast({:ask, volume, price}, state) do
    {:noreply, Engine.add_ask(state, volume, price)}
  end

  @impl true
  def handle_call(:status, _from, state) do
    {:reply, state, state}
  end
end
