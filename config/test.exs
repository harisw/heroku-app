use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :heroku, Heroku.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :heroku, Heroku.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "heroku_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
