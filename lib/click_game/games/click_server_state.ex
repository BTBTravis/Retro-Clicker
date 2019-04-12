defmodule ClickGame.Games.ClickServerState do
  @enforce_keys [:clicks, :game_id]
  defstruct name: "Double Click", 
    clicks: 0, 
    rate: 0, 
    game_id: 1
end
