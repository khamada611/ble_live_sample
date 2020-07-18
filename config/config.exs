# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :ble_live_sample, BleLiveSampleWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "LhP9x3r+giRRyD9KdHPOuy3WcX6u+dJWAUktLcD1spo8G10BjLprbQicMrr4WFO5",
  render_errors: [view: BleLiveSampleWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: BleLiveSample.PubSub,
  live_view: [signing_salt: "JEM2Ojvh"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
