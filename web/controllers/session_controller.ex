defmodule Heroku.SessionController do
    use Heroku.Web, :controller

    def new(conn, _) do
        render conn, "new.html"
    end

    def create(conn, %{"session" => %{"username" => username, "password" => password } } ) do
        case Heroku.Auth.login_by_username_and_pass(conn, username, password, repo: Repo) do
            {:ok, conn} ->
                conn
                |> put_flash(:info, "Welcome back")
                |> redirect(to: room_path(conn, :index))
            {:error, _reason, conn} ->
                conn
                |> put_flash(:error, "Invalid username or password")
                |> render("new.html")
        end
    end

    def delete(conn, _) do
        conn
        |> Heroku.Auth.logout()
        |> redirect(to: page_path(conn, :index))
    end

end