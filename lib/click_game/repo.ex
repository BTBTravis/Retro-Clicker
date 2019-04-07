defmodule ClickGame.Repo do
  use Ecto.Repo,
    otp_app: :click_game,
    adapter: Ecto.Adapters.Postgres
end
