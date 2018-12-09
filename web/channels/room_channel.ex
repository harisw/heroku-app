defmodule Heroku.RoomChannel do
    use Heroku.Web, :channel
    require Logger

    def join("room:" <> room_slug, _params, socket) do
        Logger.debug "Slug value: |#{room_slug}|"
        room = Repo.get_by!(Heroku.Room, slug: String.trim(room_slug))

        chats = Repo.all(
            from a in assoc(room, :chats),
                order_by: [asc: a.inserted_at],
                preload: [:user, :room]
        )
        resp = %{chats: Phoenix.View.render_many(chats, Heroku.ChatView, "chat.json")}
        {:ok, resp, assign(socket, :room_id, room.id)}
    end

    def handle_in(event, params, socket) do
        user = Repo.get(Heroku.User, socket.assigns.user_id)
        handle_in(event, params, user, socket)
    end

    def handle_in("new chat", params, user, socket) do
        changeset = 
        user
        |> build_assoc(:chats, room_id: socket.assigns.room_id)
        |> Heroku.Chat.changeset(params)

        case Repo.insert(changeset) do
            {:ok, chat} ->
                broadcast! socket, "new chat", %{
                    id: chat.id,
                    user: Heroku.UserView.render("user.json", %{user: user}),
                    body: params["content"],
                    at: params["inserted_at"]
                }
                {:reply, :ok, socket}
            {:error, changeset} ->
                {:reply, {:error, %{errors: changeset}}, socket}
        end
    end
end