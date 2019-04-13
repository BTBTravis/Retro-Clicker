defmodule ClickGame.Games.ClickServer  do
  use GenServer

  @tick_length 1000
  @sync_length 60000

  # Client
  def start_link([name, game_id]) do
    state = ClickGame.Games.handle_click_server_init(game_id)
    GenServer.start_link(__MODULE__, state, name: name)
  end

  def click(pid) do
    # GenServer.cast(pid, :click)
    GenServer.call(pid, :click)
  end

  def refresh(pid) do
    Process.send(pid, :refresh, [:noconnect])
    #Process.send(pid, :refresh, [:ok])
  end

  def get_clicks(pid) do
    GenServer.call(pid, :get_clicks)
  end

  # Server (callbacks)
  @impl true
  def init(initValues) do
    Process.send_after(self(), :tick, @tick_length)
    Process.send_after(self(), :sync, @sync_length)

    {:ok, initValues}
  end

  # def handle_cast(:click, state) do

  @impl true
  def handle_call(:click, _from, state) do
    newState = %{state | clicks: state.clicks + 1}
    {:reply, newState.clicks, newState}
  end

  @impl true
  def handle_call(:get_clicks, _from, state) do
    {:reply, state.clicks, state}
  end

  @impl true
  def handle_info(:refresh, state) do
    newState = ClickGame.Games.handle_click_server_refresh(state)
    {:noreply, newState}
  end

  @impl true
  def handle_info(:tick, state) do
    Process.send_after(self(), :tick, @tick_length)
    {:noreply, %{state | clicks: state.clicks + state.rate}}
  end

  def handle_info(:sync, state) do
    Process.send_after(self(), :sync, @sync_length)
    ClickGame.Games.sync_clicks(state.game_id, state.clicks)
    {:noreply, state}
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
