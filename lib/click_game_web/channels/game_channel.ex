defmodule ClickGameWeb.GameChannel do
  use ClickGameWeb, :channel

  alias ClickGame.Games
  alias ClickGame.Games.Game

  def join("game:" <> game_id, _params, socket) do
    if true do
      case Games.get_game!(game_id) do
        %Game{} -> 
          send(self(), :after_join)
          {:ok, socket}
        _ -> {:error, %{reason: "unauthorized"}}
      end
    else
      {:error, %{reason: "unauthorized"}}
    end

  end

  # Channels can be used in a request/response fashion
  def handle_in("click", _payload, socket) do
    Games.single_click(1)
    {:reply, :ok, socket}
  end
  # by sending replies to requests from the client
  #def handle_in("ping", payload, socket) do
    #{:reply, {:ok, payload}, socket}

    #{:reply, :ok, socket}
    #{:reply, {:ok, %{}}, socket}
    #{:stop, :shutdown, {:error, %{}}, socket}
  #end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (game:lobby).
  #def handle_in("shout", payload, socket) do
    #broadcast socket, "shout", payload
    #{:noreply, socket}
  #end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end

  def handle_info(:after_join, socket) do
    {game_id, ""} = Regex.named_captures(~r/game:(?<id>\d+)/, socket.topic)["id"]
              |> Integer.parse
    push(socket, "game_update", 
     game_update_msg(ClickGame.Games.get_game_full!(game_id)))

    {:noreply, socket}
  end

  def game_update_msg(game) do 
    state = %{
      :store_clickers => ClickGame.Games.Store.get_clickers(game.clickers),
      :clickers => game.clickers
    }
    Phoenix.View.render(ClickGameWeb.GameStateView, "state.json", state)
  end
end
