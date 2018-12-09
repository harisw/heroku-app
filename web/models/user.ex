defmodule Heroku.User do
  use Heroku.Web, :model

  schema "users" do
    field :password_hash, :string
    field :password, :string, virtual: true
    field :username, :string
    field :name, :string
    field :phone, :string

    has_many :chats, Heroku.Chat
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :name])
    |> validate_required([:username, :name])
    |> unique_constraint(:username)
    |> unique_constraint(:phone)
  end

  def registration_changeset(user, params) do
    user
    |> changeset(params)
    |> cast(params, ~w(password), [])
    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end

end
