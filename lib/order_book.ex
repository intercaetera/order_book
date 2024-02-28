defmodule OrderBook do
  @moduledoc """
  OrderBook keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias OrderBook.BookServer

  defdelegate ask(name, volume, price), to: BookServer
  defdelegate bid(name, volume, price), to: BookServer

  def find_or_create_book(name) do
    case Registry.lookup(Registry.BookRegistry, name) do
      [] ->
        BookServer.start_link(name)
        BookServer.status(name)

      _ ->
        BookServer.status(name)
    end
  end
end
