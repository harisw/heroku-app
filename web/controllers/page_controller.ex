defmodule Heroku.PageController do
  use Heroku.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
