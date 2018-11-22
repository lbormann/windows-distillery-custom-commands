# Sample Project for a working Windows-Elixir-Distillery-Custom-Commands-Configuration.

## Created and tested with following System configuration

  * Windows 10 Pro x64
  * Elixir 1.7.4
  * Erlang/OTP 21 (compiled w/ 19)
  * Phoenix 1.4
  * Ecto 3.0.3
  * Distillery 2.0.12
  * PostgreSQL 10

## Test-Workflow:

Load dependencies:

$   mix deps.get --only prod

Build a release:

$   set "MIX_ENV=prod" && mix release --env=prod

Then you cam execute one of the custom commands:


init (db create, migrate, seed)

$    set "COOKIE=MY_PROD_SECRET" && .\_build\prod\rel\phoenix_distillery\bin\phoenix_distillery.bat init

create (db create)

$    set "COOKIE=MY_PROD_SECRET" && .\_build\prod\rel\phoenix_distillery\bin\phoenix_distillery.bat init

drop (db drop)

$    set "COOKIE=MY_PROD_SECRET" && .\_build\prod\rel\phoenix_distillery\bin\phoenix_distillery.bat drop

migrate (db migrate)

$    set "COOKIE=MY_PROD_SECRET" && .\_build\prod\rel\phoenix_distillery\bin\phoenix_distillery.bat migrate

seed (db seed)

$    set "COOKIE=MY_PROD_SECRET" && .\_build\prod\rel\phoenix_distillery\bin\phoenix_distillery.bat seed

reset (db reset)

$    set "COOKIE=MY_PROD_SECRET" && .\_build\prod\rel\phoenix_distillery\bin\phoenix_distillery.bat reset




## Keyfacts for a working configuration:

	1. In the "ReleaseTasks-Module" you need to change ":ecto" to ":ecto_sql" in your constant "@start_apps"
	2. In generel, configuration in config-Files doesnt work for me! (Problem: the program cant find the DB-Connection-Fields like ":database" for example! But! When you use init callback of repo it works (and.. Of course it also with with dynamic loading -> System.get(..))
	3. In the "ReleaseTasks-Module: The repo Migrator needs more then "pool_size: 1" to perform tasks parallel (at least 2). So set it to 2: "repo.start_link(pool_size: 2)"


## PS
  Thanks to user "StoatPower" for his inspiring [Elixirform Post](https://elixirforum.com/t/distillery-migrations-win-10-configuration-for-myapp-repo-not-specified-in-my-app-environment/17998):
