defmodule OrderBookWeb.PageController do
  use OrderBookWeb, :controller

  def home(conn, %{"symbol" => symbol}) do
    redirect(conn, to: ~p"/#{symbol}")
  end

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end
end
