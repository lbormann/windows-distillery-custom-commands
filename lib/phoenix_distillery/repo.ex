defmodule PhoenixDistillery.Repo do
  use Ecto.Repo,
    otp_app: :phoenix_distillery,
    adapter: Ecto.Adapters.Postgres

  def init(_arg, opts) do
    {:ok, Keyword.merge(opts, db_config())}
  end

  defp os_env!(name) do
    case System.get_env(name) do
      nil -> raise "OS ENV #{name} not set!"
      value -> value
    end
  end

  defp db_config() do
    [
      hostname: os_env!("PD_DB_HOSTNAME"),
      database: os_env!("PD_DB_DATABASE"),
      username: os_env!("PD_DB_USERNAME"),
      password: os_env!("PD_DB_PASSWORD")
    ]
  end
end
