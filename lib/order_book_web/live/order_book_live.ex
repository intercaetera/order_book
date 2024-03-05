defmodule OrderBookWeb.OrderBookLive do
  use Phoenix.LiveView

  import OrderBookWeb.OrderList

  def render(assigns) do
    ~H"""
    <div class="bg-black text-white w-screen h-screen flex flex-col justify-center items-center">
      <h1 class="text-4xl"><%= @name %> - $<%= @book.ticker %></h1>

      <div class="flex p-2">
        <.order_list type="Asks" color="darkgreen" orders={@book.asks} />
        <.order_list type="Bids" color="darkred" orders={@book.bids} />
      </div>
    </div>
    """
  end

  def mount(%{"name" => name}, _session, socket) do
    if connected?(socket), do: OrderBook.subscribe(name)

    socket =
      socket
      |> assign(:name, name)
      |> assign_book(name)

    {:ok, socket}
  end

  def handle_info(:update, socket) do
    socket =
      socket
      |> assign_book(socket.assigns.name)

    {:noreply, socket}
  end

  defp assign_book(socket, name), do: assign(socket, :book, OrderBook.find_or_create_book(name))
end
