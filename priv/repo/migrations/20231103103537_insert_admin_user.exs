defmodule TimeManager.Repo.Migrations.InsertAdminUser do
  use Ecto.Migration

  def change do
    execute """
      INSERT INTO users(
        username, email, password_hash, inserted_at, updated_at, role)
      VALUES ('admin', 'admin@admin.com', 'admin', '2023-06-10', '2023-06-10', 'admin');
    """
  end
end
