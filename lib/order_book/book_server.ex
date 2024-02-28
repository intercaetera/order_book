defmodule OrderBook.BookServer do
  use GenServer

  alias OrderBook.Engine

  def start_link(name) do
    book = Engine.new_book(name)
    GenServer.start_link(__MODULE__, book, name: via(name))
  end

  def bid(name, volume, price) do
    GenServer.cast(via(name), {:bid, volume, price})
  end

  def ask(name, volume, price) do
    GenServer.cast(via(name), {:ask, volume, price})
  end

  def status(name) do
    GenServer.call(via(name), :status)
  end

  defp via(name), do: {:via, Registry, {Registry.BookRegistry, name}}

  @impl true
  def init(initial_state) do
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
