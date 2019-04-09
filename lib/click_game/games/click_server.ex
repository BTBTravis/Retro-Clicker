defmodule ClickGame.Games.ClickServer  do
  use GenServer

  @tick_length 1000

  # Client
  def start_link([name, params]) do
    GenServer.start_link(__MODULE__, params, name: name)
  end

  def refresh(pid) do
    GenServer.cast(pid, :refresh)
  end

  def get_clicks(pid) do
    GenServer.call(pid, :get_clicks)
  end

  # Server (callbacks)
  @impl true
  def init(initValues) do
    Process.send_after(self(), :tick, @tick_length)

    {:ok, initValues}
  end

  #@impl true
  #def handle_cast(:refresh, state) do
    #{:noreply, %{state | clicks: state.clicks + state.rate}}
  #end

  @impl true
  def handle_call(:get_clicks, _from, state) do
    {:reply, state.clicks, state}
  end

  @impl true
  def handle_info(:tick, state) do
    Process.send_after(self(), :tick, @tick_length)
    {:noreply, %{state | clicks: state.clicks + state.rate}}
  end
end
  #@impl true
  #def init(args) do
    #send(self(), :deploy_course)
    #{:ok, }
  #end

  #@impl true
  #def handle_info(:deploy_course, state) do
    ## coming soon!
    #{:noreply, state}
  #end
