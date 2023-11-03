defmodule TimeManager.Accounts.UserTeam do
  alias TimeManager.Accounts.{WorkingTime, Clock, Team, UserRole}
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  @derive {Jason.Encoder, only: [:user, :team]}
  schema "users_teams" do
    belongs_to(:user, User, primary_key: true)
    belongs_to(:team, Team, primary_key: true)

    timestamps()
  end

  @doc false
  @required_fields ~w(user_id team_id)a
  def changeset(user_team, attrs) do
    user_team
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:team_id)
    |> foreign_key_constraint(:user_id)
    |> unique_constraint([:user, :team],
         name: :user_id_team_id_unique_index,
         message: @already_exists
       )
  end
end
