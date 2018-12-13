defmodule Heroku.Repo.Migrations.AddDescriptionRoom do
  use Ecto.Migration

  def change do
    alter table(:rooms) do
      add :description, :text
    end
  end
end
