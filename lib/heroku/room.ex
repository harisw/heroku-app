defmodule Heroku.Room do
  use Ecto.Schema
  import Ecto.Changeset


  schema "rooms" do
    field :name, :string
    field :password_hash, :string
    field :slug, :string

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name, :password_hash, :slug])
    |> validate_required([:name, :password_hash, :slug])
  end
end
