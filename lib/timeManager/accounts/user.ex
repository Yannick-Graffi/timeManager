defmodule TimeManager.Accounts.User do
  alias TimeManager.Accounts.WorkingTime
  alias TimeManager.Accounts.Clock
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :email, :string
    has_many :clocks, Clock
    has_many :working_times, WorkingTime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email])
    |> validate_required([:username, :email])
  end
end
