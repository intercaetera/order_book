defmodule OrderBook.Repo do
  use Ecto.Repo,
    otp_app: :order_book,
    adapter: Ecto.Adapters.SQLite3
end
