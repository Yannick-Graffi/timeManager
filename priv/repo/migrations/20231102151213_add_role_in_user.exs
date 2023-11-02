defmodule TimeManager.Repo.Migrations.AddRoleInUser do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :roles, {:array, Ecto.Enum}, values: [:admin, :general_manager, :manager, :employee]
    end
  end
end
