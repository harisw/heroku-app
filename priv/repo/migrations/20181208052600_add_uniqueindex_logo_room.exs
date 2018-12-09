defmodule Heroku.Repo.Migrations.AddUniqueindexLogoRoom do
  use Ecto.Migration

  def change do
    alter table(:rooms) do
      add :logo, :string
    end

    create unique_index(:rooms, [:name])
  end
end
