# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PhoenixDistillery.Repo.insert!(%PhoenixDistillery.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias PhoenixDistillery.{Blog, Repo}

_post =
  %Blog.Post{title: "My furst poast", views: 0}
  |> Repo.insert!()
