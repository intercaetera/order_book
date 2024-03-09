defmodule OrderBookWeb.OrderList do
  use Phoenix.Component

  attr :type, :string, required: true
  attr :color, :string, required: true
  attr :orders, :list, required: true

  def order_list(assigns) do
    ~H"""
    <div class="p-2" style={"background: #{@color};"}>
      <strong><%= @type %></strong>
      <ul>
        <li :for={{price, volume} <- format_orders(@orders, @type)}>
          <%= volume %> for $<%= price %>
        </li>
      </ul>
    </div>
    """
  end

  def format_orders(orders, type) do
    orders
    |> Enum.frequencies()
    |> Enum.sort(if type == "Asks", do: :asc, else: :desc)
    |> Enum.take(5)
  end
end
