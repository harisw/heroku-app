defmodule Heroku.ChatView do
    use Heroku.Web, :view

    def render("chat.json", %{chat: chat}) do
        %{
            id: chat.id,
            content: chat.content,
            at: chat.inserted_at,
            user: render_one(chat.user, Heroku.UserView, "user.json")
        }
    end
end