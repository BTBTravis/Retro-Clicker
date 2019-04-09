defmodule ClickGame.Games.ClickSupervisor do
  use DynamicSupervisor

  alias ClickGame.Games.ClickStore
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
#defmodule ClickGame.Games.ClickSupervisor do
#use Supervisor
#alias ClickGame.Games.ClickServer

#def start_link(init_arg) do
##Supervisor.start_link(__MODULE__, :ok, opts)
#Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
#end


#@impl true
#def init(_init_arg) do
#children = [
#Supervisor.child_spec({ClickServer, %{:clicks => 0, :rate => 1}}, id: {ClickServer, 1}),
#Supervisor.child_spec({ClickServer, %{:clicks => 0, :rate => 10}}, id: {ClickServer, 2})
#]

#Supervisor.init(children, strategy: :one_for_one)
#end
#end
