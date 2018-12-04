defmodule Heroku.RoomController do
    use Heroku.Web, :controller
    plug :authenticate_user
    def index(conn, _params) do

        render conn, "index.html"
    end
end