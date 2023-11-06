defmodule TimeManager.Accounts.Team do
  use Ecto.Schema
  import Ecto.Changeset
  alias TimeManager.Accounts.User

  @derive {Jason.Encoder, only: [:name]}
  schema "teams" do
    field :name, :string
    belongs_to :manager, User
    many_to_many :users, User, join_through: "users_teams"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name, :manager_id])
    |> validate_required([:name, :manager_id])
  end
end
