defmodule Heroku.Chat do
  use Heroku.Web, :model

  schema "chats" do
    field :content, :string
    belongs_to :user, Heroku.User, foreign_key: :user_id
    belongs_to :room, Heroku.Room, foreign_key: :room_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:content])
    |> validate_required([:content])
  end
end
