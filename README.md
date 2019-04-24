# Retro Clicker

An idle clicker game base on the idea of slow play.

## Dev Env Setup
Requirements:

* Need [elixir](https://elixir-lang.org/) installed locally 
* Need docker and docker-compose installed locally

*Phoenix Setup:*

1. Start the postgres and adminer container:
`$ docker-compose up -f docker-compose-dev.yml -d up`
1. Install dependencies:
`$ mix deps.get`
1. Init db:
`$ mix ecto.setup`
1. Reset db as needed:
`$ mix ecto.reset`
1. Start up server (`localhost:4000`) with repl
`$ iex -S mix phx.server`

*JS + CSS Setup:*

1. Go to frontend assets folder:
`$ cd priv/src`
1. Build js and css assets:
`$ npm run build`
1. Init hot js reloader:
`$ npm run dev-js`

## Helpful dev links

* [plug docs](https://hexdocs.pm/plug/readme.html)
* [phoenix html docs](https://hexdocs.pm/phoenix_html/Phoenix.HTML.html)
* [EEx docs](https://hexdocs.pm/eex/EEx.html#content)
* [ecto docs](https://hexdocs.pm/ecto/Ecto.html)
* [phoenix docs](https://hexdocs.pm/phoenix/Phoenix.html)
* [tailwind docs](https://tailwindcss.com/docs/what)
* [local app](http://localhost:4000)
* [local db](http://localhost:8080/?pgsql=postgres&username=devpostgres&db=click_game_dev&ns=public&select=games)
