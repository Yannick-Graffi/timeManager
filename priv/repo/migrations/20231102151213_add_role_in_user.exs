defmodule TimeManager.Repo.Migrations.AddRoleInUser do
  use Ecto.Migration
  alias TimeManager.Accounts.UserRole

  def change do
    UserRole.create_type()

    alter table("users") do
      add :role, :user_role, null: false
    end
  end
end
