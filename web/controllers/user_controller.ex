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
        img_path = moveAvatar(user_params)
        changeset = User.apply_changeset(%User{}, user_params, img_path)
        case Repo.insert(changeset) do
            {:ok, user} ->
                conn
                |> Heroku.Auth.login(user)
                |> put_flash(:info, "#{user.name} created!")
                |> redirect(to: room_path(conn, :index))
            {:error, changeset} ->
                redirect(conn, to: user_path(conn, :new), changeset: changeset)
        end
    end

    def edit(conn, %{"id" => id}) do
        user = Repo.get!(User, id)
        changeset = User.changeset(user)
        render conn, "edit.html", user: user, changeset: changeset
    end

    def update(conn, %{"id" => id, "user" => user_params}) do
        user = Repo.get!(User, id)
        img_path = moveAvatar(user_params)
        changeset = User.apply_changeset(user, user_params, img_path)

        case Repo.update(changeset) do
            {:ok, _user} ->
                conn
                |> put_flash(:info, "User updated")
                |> redirect(to: room_path(conn, :index))
            {:error, changeset} ->
                render(conn, "edit.html", user: user, changeset: changeset)
        end
    end
    
    defp moveAvatar(user_params) do
        base_path = Application.get_env(:heroku, Heroku.Endpoint)[:media_path]
        IO.inspect user_params["avatar_file"]
        case user_params["avatar_file"] do
            nil ->
                user_params["avatar"]
            upload ->
                username = user_params["username"]
                extension = Path.extname(upload.filename)
                new_file = "avatars/#{username}#{extension}"
                File.cp!(upload.path, "#{base_path}#{new_file}")
                "/uploads/#{new_file}"
        end
    end
end