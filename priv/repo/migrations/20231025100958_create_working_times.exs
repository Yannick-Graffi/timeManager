defmodule TimeManager.Repo.Migrations.CreateWorkingTimes do
  use Ecto.Migration

  def change do
    create table(:working_times) do
      add :start, :utc_datetime
      add :end, :utc_datetime
      add :users_id, references(:users)
    end
  end
end
