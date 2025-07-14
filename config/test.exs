import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :rumbl, Rumbl.Repo,
  username: "ecobet",
  password: "ecobet",
  hostname: "localhost",
  database: "rumbl_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :rumbl_web, RumblWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "GsJSj4c0JutLH2yuGw3/ul6LTZaQx4M5C7wVuytWgkp40lUYsuSsRWneHkCHoVA/",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# In test we don't send emails
config :rumbl, Rumbl.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true

config :info_sys, :wolfram,
  app_id: "1234",
  http_client: InfoSys.Test.HTTPClient
