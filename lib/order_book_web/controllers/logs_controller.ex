defmodule OrderBookWeb.LogsController do
  use OrderBookWeb, :controller

  def home(conn, _params) do
    conn
    |> assign(:logs, OrderBook.get_all_logs())
    |> render(:home, layout: false)
  end
  
end
