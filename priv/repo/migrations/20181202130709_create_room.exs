defmodule Heroku.Repo.Migrations.CreateRoom do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string
      add :password_hash, :string
      add :slug, :string

      timestamps()
    end
  end
end
