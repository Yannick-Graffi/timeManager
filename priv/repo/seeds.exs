# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TimeManager.Repo.insert!(%TimeManager.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


# priv/repo/seeds.exs

alias TimeManager.Repo
alias TimeManager.Accounts.User

# Supprimez tous les utilisateurs existants (optionnel)
# Repo.delete_all(User)

# Liste des utilisateurs à ajouter
users = [
  %{username: "john_doe", email: "john@example.com", password: "123456", role: :employee},
  %{username: "john_doe", email: "john@example.com", password: "123456", role: :employee},
  %{username: "jane_smith", email: "jane@example.com", password: "abcdef", role: :employee},
  %{username: "bob_jones", email: "bob@example.com", password: "securepassword", role: :employee},
  %{username: "alice_brown", email: "alice@example.com", password: "anothersecure", role: :employee},
  %{username: "jane_doe", email: "jane@example.com", password: "abcdef", role: :manager},
  %{username: "admin", email: "admin@admin.com", password: "admin", role: :admin},
  # Ajoutez plus d'utilisateurs ici
]

# Insérer les utilisateurs dans la base de données
Enum.each(users, fn user_attrs ->
  user_changeset = User.changeset(%User{}, user_attrs)

  case Repo.insert(user_changeset) do
    {:ok, user} ->
      IO.puts("Created user: #{user.username}")
    {:error, changeset} ->
      IO.puts("Error creating user: #{changeset.errors |> Enum.map(fn {k, v} -> "#{k}: #{elem(v, 1)}" end) |> Enum.join(", ")}")
  end
end)
