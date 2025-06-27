defmodule Rumbl.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Rumbl.Repo,
      {DNSCluster, query: Application.get_env(:rumbl, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Rumbl.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Rumbl.Finch}
      # Start a worker by calling: Rumbl.Worker.start_link(arg)
      # {Rumbl.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Rumbl.Supervisor)
  end
end
