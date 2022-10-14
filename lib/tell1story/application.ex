defmodule Tell1story.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Tell1story.Repo,
      # Start the Telemetry supervisor
      Tell1storyWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Tell1story.PubSub},
      # Start the Endpoint (http/https)
      Tell1storyWeb.Endpoint
      # Start a worker by calling: Tell1story.Worker.start_link(arg)
      # {Tell1story.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Tell1story.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Tell1storyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
