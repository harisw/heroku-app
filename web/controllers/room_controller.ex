defmodule Heroku.RoomController do
    use Heroku.Web, :controller
    alias Heroku.Room
    plug :authenticate_user
    
    def index(conn, _params) do
        changeset = Room.changeset(%Room{})
        render conn, "index.html", changeset: changeset
    end
end