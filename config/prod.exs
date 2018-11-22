use Mix.Config

# For production, don't forget to configure the url host
# to something meaningful, Phoenix uses this information
# when generating URLs.
#
# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix phx.digest` task,
# which you should run after static files are built and
# before starting your production server.
config :phoenix_distillery, PhoenixDistilleryWeb.Endpoint,
  http: [port: 4000],
  url: [host: "localhost", port: 4000],
  server: true,
  root: ".",
  version: Application.spec(:phoenix_distillery, :vsn)

# Do not print debug messages in production
config :logger, level: :info

config :phoenix_distillery, PhoenixDistilleryWeb.Endpoint,
  secret_key_base: "9sOZhd34kO1gNo7O7eT45VaOe6wVqcHUu3+uN24yd5Witk1+E3zGtt5fs9wp2G66"

# Configure your database
config :phoenix_distillery, PhoenixDistillery.Repo,
  username: "postgres",
  password: "postgres",
  database: "phoenix_distillery_prod",
  hostname: "localhost",
  pool_size: 15,
  logger: []
