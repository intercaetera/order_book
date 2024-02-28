defmodule OrderBook.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      OrderBookWeb.Telemetry,
      # Start the Ecto repository
      OrderBook.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: OrderBook.PubSub},
      # Start the Endpoint (http/https)
      OrderBookWeb.Endpoint,
      # Start order book registry
      {Registry, keys: :unique, name: Registry.BookRegistry}
      # Start a worker by calling: OrderBook.Worker.start_link(arg)
      # {OrderBook.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: OrderBook.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    OrderBookWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
