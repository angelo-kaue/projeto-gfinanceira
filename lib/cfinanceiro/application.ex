defmodule Cfinanceiro.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CfinanceiroWeb.Telemetry,
      Cfinanceiro.Repo,
      {DNSCluster, query: Application.get_env(:cfinanceiro, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Cfinanceiro.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Cfinanceiro.Finch},
      # Start a worker by calling: Cfinanceiro.Worker.start_link(arg)
      # {Cfinanceiro.Worker, arg},
      # Start to serve requests, typically the last entry
      CfinanceiroWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Cfinanceiro.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CfinanceiroWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
