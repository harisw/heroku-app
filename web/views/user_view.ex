defmodule Heroku.UserView do
    use Heroku.Web, :view

    def render("user.json", %{user: user}) do
        %{username: user.username, avatar: user.avatar}
    end
end