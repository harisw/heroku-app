defmodule Heroku.UserView do
    use Heroku.Web, :view
    alias Heroku.User

    def render("user.json", %{user: user}) do
        %{username: user.username}
    end
end