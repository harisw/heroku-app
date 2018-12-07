defmodule Heroku.RoomController do
    use Heroku.Web, :controller
    alias Heroku.Room
    plug :authenticate_user
    
    def index(conn, _params) do
        changeset = Room.changeset(%Room{})
        render conn, "index.html", changeset: changeset
    end

    def show(conn, %{"slug" => slug}) do
        room = Repo.get_by!(Heroku.Room, slug: slug)
        chats = Repo.preload room, :chats
        render conn, "show.html", room: room, chats: chats
    end

    def create(conn, %{"room" => room_params}) do
        changeset = Room.creation_changeset(%Room{}, room_params)
        case Repo.insert(changeset) do
            {:ok, room} ->
                conn
                |> redirect(to: room_path(conn, :show, room))
            {:error, changeset} ->
                redirect(conn, to: room_path(conn, :index))
        end
    end
end