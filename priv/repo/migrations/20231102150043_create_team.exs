defmodule TimeManager.Repo.Migrations.CreateTeam do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string, null: false
      add :manager_id, references(:users), null: false

      timestamps(type: :utc_datetime)
    end
  end
end
