defmodule OrderBookWeb.OrderBookLive do
  import OrderBookWeb.CoreComponents
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

      <form phx-submit="submit" class="flex flex-col items-center">
        <.input type="number" label="Volume" name="volume" value="" />
        <.input type="number" label="Price" name="price" value="" />
        <div class="flex">
          <.button name="ask" class="m-2">Ask</.button>
          <.button name="bid" class="m-2">Bid</.button>
        </div>
      </form>
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

  def handle_event("submit", unsigned_params, socket) do
    :ok = unsigned_params
    |> cast()
    |> bid_or_ask(socket.assigns.name)

    {:noreply, socket}
  end

  def handle_info(:update, socket) do
    socket =
      socket
      |> assign_book(socket.assigns.name)

    {:noreply, socket}
  end

  defp assign_book(socket, name), do: assign(socket, :book, OrderBook.find_or_create_book(name))

  defp cast(%{"ask" => _, "volume" => volume, "price" => price}) do
    %{ask: true, volume: String.to_integer(volume), price: String.to_integer(price)}
  end

  defp cast(%{"bid" => _, "volume" => volume, "price" => price}) do
    %{bid: true, volume: String.to_integer(volume), price: String.to_integer(price)}
  end

  defp cast(_), do: %{}

  defp bid_or_ask(%{ask: true, volume: volume, price: price}, name)
       when volume > 0 and price > 0 do
    OrderBook.ask(name, volume, price)
  end

  defp bid_or_ask(%{bid: true, volume: volume, price: price}, name)
       when volume > 0 and price > 0 do
    OrderBook.bid(name, volume, price)
  end

  defp bid_or_ask(_, _), do: :ok
end
