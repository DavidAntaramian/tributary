use Mix.Config

config :tributary, ecto_repos: [Tributary.Repo]

config :tributary, Tributary.Repo,
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox,
  database: "tributary_test",
  username: System.get_env("TRIBUTARY_DB_USER") || System.get_env("USER")

config :logger, :console,
  level: :error
