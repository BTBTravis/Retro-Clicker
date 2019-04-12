defmodule ClickGame.Games.ClickSupervisor do
  use DynamicSupervisor

  alias ClickGame.Games.ClickServer

  def start_link(_arg) do
    res = DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)

    # Start click store
    with {:ok, _} <- res do
      {:ok, _} = Registry.start_link(keys: :unique, name: Registry.ClickStore)
      ClickGame.Games.start_click_servers()
    end
    res
  end

  def start_click_server(index, params) do
    name = {:via, Registry, {Registry.ClickStore, index}}
    spec = {ClickServer, [name, params]}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end

# Get pid of ClickServer by index
#iex(6)> [{pid_3, nil}] = Registry.lookup(Registry.ClickStore, 3)
