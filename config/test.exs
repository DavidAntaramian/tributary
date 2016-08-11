use Mix.Config

config :tributary, ecto_repos: [Tributary.Repo]

config :tributary, Tributary.Repo,
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox,
  url: System.get_env("DATABASE_URL")

config :logger, :console,
  level: :error
