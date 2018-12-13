defmodule Heroku.Repo.Migrations.AddUserlimitAndTipeRoom do
  use Ecto.Migration

  def change do
    alter table(:rooms) do
      add :user_limit, :integer, default: nil
      add :type, :integer
    end
  end
end
