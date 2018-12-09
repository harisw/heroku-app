defmodule Heroku.UserController do
    use Heroku.Web, :controller
    require Logger
    alias Heroku.User
    plug :authenticate_user when action in [:show]

    def index(conn, _params) do
        users = Repo.all(User)
        render conn, "index.html", users: users
    end

    def show(conn, %{"id" => id}) do
        user = Repo.get(User, id)
        render conn, "show.html", user: user
    end

    def new(conn, _params) do
        changeset = User.changeset(%User{})
        render conn, "new.html", changeset: changeset
    end

    def create(conn, %{"user" => user_params}) do
        moveAvatar(conn, user_params)
        changeset = User.registration_changeset(%User{}, user_params, nil)
        case Repo.insert(changeset) do
            {:ok, user} ->
                conn
                |> Heroku.Auth.login(user)
                |> put_flash(:info, "#{user.name} created!")
                |> redirect(to: room_path(conn, :index))
            {:error, changeset} ->
                redirect(conn, to: user_path(conn, :new))
        end
    end

    def edit(conn, %{"id" => id}) do
        user = Repo.get!(User, id)
        changeset = User.changeset(user)
        render conn, "edit.html", user: user, changeset: changeset
    end

    defp moveAvatar(conn, user_params) do
        # base_url = System.get_env("BASE_URL")
        # Logger.info "BASE URL#{base_url}"
        if upload = user_params["avatar"] do
            username = user_params["username"]
            extension = Path.extname(upload.filename)
            File.cp!(upload.path, "web/static/assets/images/avatars/#{username}#{extension}")
        end
    end
end