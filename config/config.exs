# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :heroku,
  ecto_repos: [Heroku.Repo]

# Configures the endpoint
config :heroku, Heroku.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "wjChOPMSjmsFJKKfZY9i6kk6jMizJIzfcHQyJlZry9n5fe+avJjqrzI3kxFYOGrm",
  render_errors: [view: Heroku.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Heroku.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
