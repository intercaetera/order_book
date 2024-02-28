defmodule OrderBookWeb.OrderBookLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~H"""
    <div class="bg-black text-white w-screen h-screen flex flex-col justify-center items-center">
      <h1 class="text-4xl"><%= @book.name %> $<%= @book.ticker %></h1>

      <div class="flex p-2">
        <div class="bg-green-900 p-2">
          Asks
          <ul>
            <li :for={{price, volume} <- format_orders(@book.asks)}>
              <%= volume %> for $<%= price %>
            </li>
          </ul>
        </div>

        <div class="bg-red-900 p-2">
          Bids
          <ul>
            <li :for={{price, volume} <- format_orders(@book.bids)}>
              <%= volume %> for $<%= price %>
            </li>
          </ul>
        </div>
      </div>
    </div>
    """
  end

  def mount(%{"name" => name}, _session, socket) do
    socket =
      socket
      |> assign(:book, OrderBook.find_or_create_book(name))

    {:ok, socket}
  end

  def format_orders(orders) do
    orders
    |> Enum.frequencies()
    |> Enum.take(5)
  end
end
