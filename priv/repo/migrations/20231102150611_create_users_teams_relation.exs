defmodule TimeManager.Repo.Migrations.CreateUsersTeamsRelation do
  use Ecto.Migration

  def change do
    create table(:users_teams, primary_key: false) do
      add(:team_id, references(:teams, on_delete: :delete_all), primary_key: true)
      add(:user_id, references(:users, on_delete: :delete_all), primary_key: true)
    end

    create(index(:users_teams, [:team_id]))
    create(index(:users_teams, [:user_id]))
  end
end
