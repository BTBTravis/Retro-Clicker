defmodule ClickGame.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      ClickGame.Repo,
      # Start the endpoint when the application starts
      ClickGameWeb.Endpoint,
      # Starts a worker by calling: ClickGame.Worker.start_link(arg)
      # {ClickGame.Worker, arg},

      {ClickGame.Games.ClickSupervisor, [[]]},
      #{
	#id: ClickGame.Games.ClickSupervisor,
	#start: {ClickGame.Games.ClickSupervisor, :start_link, [[]]}
      #}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ClickGame.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ClickGameWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
