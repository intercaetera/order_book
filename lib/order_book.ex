defmodule OrderBook do
  @moduledoc """
  OrderBook keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  @topic "book:"

  alias OrderBook.{BookServer, TradeLog}

  defdelegate get_all_logs(), to: TradeLog

  def subscribe(name) do
    Phoenix.PubSub.subscribe(OrderBook.PubSub, @topic <> name)
  end

  def ask(name, volume, price) do
    BookServer.ask(name, volume, price)
    TradeLog.create_log(name, :ask, volume, price)
    Phoenix.PubSub.broadcast(OrderBook.PubSub, @topic <> name, :update)
    :ok
  end

  def bid(name, volume, price) do
    BookServer.bid(name, volume, price)
    TradeLog.create_log(name, :bid, volume, price)
    Phoenix.PubSub.broadcast(OrderBook.PubSub, @topic <> name, :update)
    :ok
  end

  def find_or_create_book(name) do
    case (name |> String.to_atom() |> Process.whereis()) do
      nil ->
        DynamicSupervisor.start_child(OrderBook.BookSupervisor, {BookServer, name})
        BookServer.status(name)

      _ ->
        BookServer.status(name)
    end
  end
end
