defmodule OrderBookWeb.OrderList do
  use Phoenix.Component

  attr :type, :string, required: true
  attr :color, :string, required: true
  attr :orders, :list, required: true

  def order_list(assigns) do
    ~H"""
    <div class="p-2" style={"background: #{@color};"}>
      <strong><%= String.capitalize(@type) %></strong>
      <ul>
        <li :for={{price, volume} <- format_orders(@orders)}>
          <%= volume %> for $<%= price %>
        </li>
      </ul>
    </div>
    """
  end

  def format_orders(orders) do
    orders
    |> Enum.frequencies()
    |> Enum.take(5)
  end
end
