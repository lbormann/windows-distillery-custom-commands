defmodule PhoenixDistillery.ReleaseTasks do
  @moduledoc """
  ReleaseTasks provides equivalents of mix ecto.*-Commands, which are not available by default in production environment.
  Source: https://github.com/elixir-ecto/ecto/tree/master/lib/mix/tasks
  """

  @start_apps [
    :crypto,
    :ssl,
    :postgrex,
    :ecto_sql
  ]
  @repos Application.get_env(:phoenix_distillery, :ecto_repos, [])

  # Name of application
  defp myapp, do: :phoenix_distillery

  # Equivalent to "mix ecto.setup"
  def db_init(_argv) do
    start_dependencies()
    create_databases()
    start_repos()
    migrate_repos()
    seed_repos()
    shutdown()
  end

  # Equivalent to "mix ecto.create"
  def db_create(_argv) do
    start_dependencies()
    create_databases()
    shutdown()
  end

  # Equivalent to "mix ecto.drop"
  def db_drop(_argv) do
    start_dependencies()
    drop_databases()
    shutdown()
  end

  # Equivalent to "mix ecto.migrate"
  def db_migrate(_argv) do
    start_dependencies()
    start_repos()
    migrate_repos()
    shutdown()
  end

  # Equivalent to "mix run priv/repo/seeds.exs"
  def db_seed(_argv) do
    start_dependencies()
    start_repos()
    seed_repos()
    shutdown()
  end

  # Equivalent to "mix ecto.reset"
  def db_reset(_argv) do
    start_dependencies()
    drop_databases()
    create_databases()
    start_repos()
    migrate_repos()
    seed_repos()
    shutdown()
  end

  # ---------------------------------------------------------------------------

  defp start_dependencies do
    IO.puts(">>>>>>>> Start depedencies..")
    Enum.each(@start_apps, &Application.ensure_all_started/1)
  end

  defp shutdown do
    IO.puts(">>>>>>>> Completed..")
    :init.stop()
  end

  defp create_databases do
    Enum.each(@repos, fn repo ->
      case repo.__adapter__.storage_up(repo.config) do
        :ok ->
          IO.puts(">>>>>>>> Database for #{inspect(repo)} created..")

        {:error, :already_up} ->
          IO.puts(">>>>>>>> Database for #{inspect(repo)} already exists..")

        {:error, term} when is_binary(term) ->
          IO.puts(">>>>>>>> Database for #{inspect(repo)} couldn't create: #{term}..")

          raise ">>>>>>>> Database for #{inspect(repo)} couldn't create: #{term}.."

        {:error, term} ->
          IO.puts(">>>>>>>> Database for #{inspect(repo)} couldn't create: #{inspect(term)}..")

          raise ">>>>>>>> Database for #{inspect(repo)} couldn't create: #{inspect(term)}.."
      end
    end)
  end

  defp drop_databases do
    Enum.each(@repos, fn repo ->
      case repo.__adapter__.storage_down(repo.config) do
        :ok ->
          IO.puts(">>>>>>>> Database for #{inspect(repo)} deleted..")

        {:error, :already_down} ->
          IO.puts(">>>>>>>> Database for #{inspect(repo)} doesn't exist..")

        {:error, term} when is_binary(term) ->
          IO.puts(">>>>>>>> Database for #{inspect(repo)} couldn't delete: #{term}..")

          raise ">>>>>>>> Database for #{inspect(repo)} couldn't delete: #{term}.."

        {:error, term} ->
          IO.puts(">>>>>>>> Database for #{inspect(repo)} couldn't delete: #{inspect(term)}..")

          raise ">>>>>>>> Database for #{inspect(repo)} couldn't delete: #{inspect(term)}.."
      end
    end)
  end

  defp start_repos do
    Enum.each(@repos, &start_repo/1)
  end

  defp start_repo(repo) do
    IO.puts(">>>>>>>> Start #{inspect(repo)}..")
    repo.start_link(pool_size: 2)
  end

  defp migrate_repos, do: Enum.each(@repos, &run_migrations_for/1)
  defp seed_repos, do: Enum.each(@repos, &run_seeds_for/1)

  defp priv_dir(app), do: "#{:code.priv_dir(app)}"

  defp run_migrations_for(repo) do
    app = Keyword.get(repo.config, :otp_app)
    IO.puts(">>>>>>>> Do migrations for #{app}..")
    Ecto.Migrator.run(repo, migrations_path(repo), :up, all: true)
  end

  defp run_seeds_for(repo) do
    seed_script = seeds_path(repo)

    if File.exists?(seed_script) do
      IO.puts(">>>>>>>> Do Seed-Script..")
      Code.eval_file(seed_script)
    end
  end

  defp migrations_path(repo), do: priv_path_for(repo, "migrations")

  defp seeds_path(repo), do: priv_path_for(repo, "seeds.exs")

  defp priv_path_for(repo, filename) do
    app = Keyword.get(repo.config, :otp_app)
    repo_underscore = repo |> Module.split() |> List.last() |> Macro.underscore()
    Path.join([priv_dir(app), repo_underscore, filename])
  end
end
