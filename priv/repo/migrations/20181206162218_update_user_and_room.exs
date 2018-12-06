defmodule Heroku.Repo.Migrations.UpdateUserAndRoom do
  use Ecto.Migration

  def change do
    alter table(:rooms) do
      add :is_online, :boolean
      add :last_update, :datetime
    end
    alter table(:users) do
      add :phone, :string
    end
  end
end
