defmodule PhoenixDistillery.Repo.Migrations.CreateBlogPosts do
  use Ecto.Migration

  def change do
    create table(:blog_posts) do
      add :title, :string
      add :views, :integer

      timestamps()
    end

  end
end
