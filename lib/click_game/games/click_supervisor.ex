defmodule ClickGame.Games.ClickSupervisor do
  use DynamicSupervisor

  alias ClickGame.Games.ClickServer

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)

    # Start click store
    {:ok, _} = Registry.start_link(keys: :unique, name: Registry.ClickStore)
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
