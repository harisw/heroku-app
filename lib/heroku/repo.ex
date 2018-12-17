defmodule Heroku.Repo do
  use Ecto.Repo, 
    otp_app: :heroku,
    adapter: Ecto.Adapters.Postgres
    
end