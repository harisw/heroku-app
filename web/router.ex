defmodule Heroku.Router do
  use Heroku.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Heroku.Auth, repo: Heroku.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Heroku do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController, only: [:index, :show, :new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/room", RoomController, only: [:index, :create, :show]
  end

  # Other scopes may use custom stacks.
  # scope "/api", Heroku do
  #   pipe_through :api
  # end
end
