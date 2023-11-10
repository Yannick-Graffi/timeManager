defmodule TimeManager.Repo do
  # Define the module for the TimeManager's database repository
  use Ecto.Repo,
    otp_app: :timeManager,
    adapter: Ecto.Adapters.Postgres
end
