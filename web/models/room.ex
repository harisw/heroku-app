defmodule Heroku.Room do
  use Heroku.Web, :model

  schema "rooms" do
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :slug, :string
    field :is_online, :boolean
    field :last_update, :utc_datetime
    field :logo, :string

    has_many :chats, Heroku.Chat
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

  def creation_changeset(room, params) do
    room
    |> changeset(params)
    |> cast(params, ~w(password), [])
    |> put_pass_hash()
    |> slugify_name()
    |> add_last_update()
    |> insert_img()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end

  defp slugify_name(changeset) do
    if name = get_change(changeset, :name) do
      put_change(changeset, :slug, slugify(name))
    else
      changeset
    end
  end

  def slugify(title) do
    title
    |> String.downcase()
    |> String.replace(~r/[^\w-]+/u, "-")
  end

  def add_last_update(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        put_change(changeset, :last_update, NaiveDateTime.utc_now())
      _ ->
       changeset 
    end
  end

  defimpl Phoenix.Param, for: Heroku.Room do
    def to_param(%{slug: slug}) do
      "#{slug}"
    end
  end

  def insert_img(changeset) do
    case get_field(changeset, :logo) do
      logo ->
        changeset
      true ->
        put_change(changeset, :logo, Phoenix.Endpoint.static_path(Phoenix.Conn, "/images/rooms/default/default.png"))
    end    
  end
end
