defmodule Heroku.Room do
  use Heroku.Web, :model

  schema "rooms" do
    field :name, :string
    field :password_hash, :string
    field :slug, :string
    field :is_online, :boolean
    field :last_update, :utc_datetime

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :password_hash, :slug])
    |> validate_required([:name, :password_hash, :slug])
  end
end
