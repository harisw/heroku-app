defmodule Heroku.Repo.Migrations.CreateChat do
  use Ecto.Migration

  def change do
    create table(:chats) do
      add :content, :text
      add :user_id, references(:users, on_delete: :delete_all)
      add :room_id, references(:rooms, on_delete: :nothing)

      timestamps()
    end

    create index(:chats, [:user_id])
    create index(:chats, [:room_id])
  end
end
