defmodule Heroku.RoomTest do
  use Heroku.ModelCase

  alias Heroku.Room

  @valid_attrs %{name: "some name", password_hash: "some password_hash", slug: "some slug"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Room.changeset(%Room{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Room.changeset(%Room{}, @invalid_attrs)
    refute changeset.valid?
  end
end
