defmodule Heroku.RoomController do
    use Heroku.Web, :controller
    alias Heroku.Room
    plug :authenticate_user
    plug :put_layout, "room.html"

    def index(conn, _params) do
        changeset = Room.changeset(%Room{})
        rooms = Repo.all(Room)
        render conn, "index.html", changeset: changeset, rooms: rooms
    end

    def show(conn, %{"slug" => slug}) do
        room = Repo.get_by!(Heroku.Room, slug: slug)
        chats = Repo.preload room, :chats
        render conn, "show.html", room: room, chats: chats
    end

    def create(conn, %{"room" => room_params}) do
        img_path = moveLogo(room_params)
        changeset = Room.creation_changeset(%Room{}, room_params, img_path)
        case Repo.insert(changeset) do
            {:ok, room} ->
                conn
                |> redirect(to: room_path(conn, :show, room))
            {:error, changeset} ->
                redirect(conn, to: room_path(conn, :index))
        end
    end

    defp moveLogo(room_params) do
        base_path = Application.get_env(:heroku, Heroku.Endpoint)[:media_path]
        IO.inspect room_params["logo_file"]
        case room_params["logo_file"] do
            nil ->
                room_params["logo"]
            upload ->
                slug = room_params["name"]
                    |> String.downcase()
                    |> String.replace(~r/[^\w-]+/u, "-")
                extension = Path.extname(upload.filename)
                new_file = "rooms/#{slug}#{extension}"
                File.cp!(upload.path, "#{base_path}#{new_file}")
                "/uploads/#{new_file}"
        end
    end
end