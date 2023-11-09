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
# Repo.delete_all(User)

alias TimeManager.Repo
alias TimeManager.Accounts.{User, Team, Clock, WorkingTime}
import Ecto.Query

################## Insert USER ##################
users = [
  %{username: "john_doe1", email: "johna@example.com", password: "Azerty123456.", role: :employee},
  %{username: "john_doe", email: "john@example.com", password: "Azerty123456.", role: :employee},
  %{username: "jane_smith", email: "jane@example.com", password: "Azerty123456.", role: :employee},
  %{username: "bob_jones", email: "bob@example.com", password: "Azerty123456.", role: :manager},
  %{username: "alice_brown", email: "alice@example.com", password: "Azerty123456.", role: :manager},
  %{username: "jane_doe", email: "jane2@example.com", password: "Azerty123456.", role: :general_manager},
]

Enum.each(users, fn user_attrs ->
  user_changeset = User.changeset(%User{}, user_attrs)

  case Repo.insert(user_changeset) do
    {:ok, user} ->
      IO.puts("Created user: #{user.username}")
    {:error, changeset} ->
      IO.puts("Error creating user: #{changeset.errors |> Enum.map(fn {k, v} -> "#{k}: #{elem(v, 1)}" end) |> Enum.join(", ")}")
  end
end)

################## Insert TEAM ##################
teams = [
  %{name: "Alpha", manager_id: "5"},
  %{name: "Bravo", manager_id: "5"},
  %{name: "Charlie", manager_id: "5"},
  %{name: "Delta", manager_id: "6"},
  %{name: "Echo", manager_id: "6"},
]

Enum.each(teams, fn team_attrs ->
  team_changeset = Team.changeset(%Team{}, team_attrs)

  case Repo.insert(team_changeset) do
    {:ok, team} ->
      IO.puts("Created team: #{team.name}")
    {:error, changeset} ->
      IO.puts("Error creating team: #{changeset.errors |> Enum.map(fn {k, v} -> "#{k}: #{elem(v, 1)}" end) |> Enum.join(", ")}")
  end
end)

################## Insert CLOCK ##################
clocks = [
  %{status: true, time: "2023-10-25 14:35:00", user_id: "2"},
  %{status: true, time: "2023-10-09 10:31:00", user_id: "3"},
  %{status: false, time: "2023-10-25 15:35:00", user_id: "4"},
  %{status: true, time: "2023-10-22 18:35:00", user_id: "5"},
  %{status: false, time: "2023-10-17 07:35:00", user_id: "6"},
]

Enum.each(clocks, fn clock_attrs ->
  clock_changeset = Clock.changeset(%Clock{}, clock_attrs)

  case Repo.insert(clock_changeset) do
    {:ok, clock} ->
      IO.puts("Created clock: #{clock.id}")
    {:error, changeset} ->
      IO.puts("Error creating clock: #{changeset.errors |> Enum.map(fn {k, v} -> "#{k}: #{elem(v, 1)}" end) |> Enum.join(", ")}")
  end
end)

################## Insert WORKING TIME ##################
now = DateTime.utc_now()

nowAddOneDay = DateTime.add(now, 1, :day)
nowAddTwoDay = DateTime.add(now, 2, :day)

workingTimes = [
  %{start: now, end: DateTime.add(now, 5, :hour), user_id: "2"},
  %{start: now, end: DateTime.add(now, 5, :hour), user_id: "3"},
  %{start: now, end: DateTime.add(now, 5, :hour), user_id: "4"},

  %{start: DateTime.add(now, 6, :hour), end: DateTime.add(now, 10, :hour), user_id: "2"},
  %{start: DateTime.add(now, 6, :hour), end: DateTime.add(now, 10, :hour), user_id: "3"},
  %{start: DateTime.add(now, 6, :hour), end: DateTime.add(now, 10, :hour), user_id: "4"},

  %{start: nowAddOneDay, end: DateTime.add(nowAddOneDay, 5, :hour), user_id: "2"},
  %{start: nowAddOneDay, end: DateTime.add(nowAddOneDay, 5, :hour), user_id: "3"},
  %{start: nowAddOneDay, end: DateTime.add(nowAddOneDay, 5, :hour), user_id: "4"},

  %{start: nowAddTwoDay, end: DateTime.add(nowAddTwoDay, 3, :hour), user_id: "2"},
  %{start: nowAddTwoDay, end: DateTime.add(nowAddTwoDay, 3, :hour), user_id: "3"},
  %{start: nowAddTwoDay, end: DateTime.add(nowAddTwoDay, 3, :hour), user_id: "4"},

  %{start: DateTime.add(nowAddTwoDay, 5, :hour), end: DateTime.add(nowAddTwoDay, 7, :hour), user_id: "2"},
  %{start: DateTime.add(nowAddTwoDay, 5, :hour), end: DateTime.add(nowAddTwoDay, 7, :hour), user_id: "3"},
  %{start: DateTime.add(nowAddTwoDay, 5, :hour), end: DateTime.add(nowAddTwoDay, 7, :hour), user_id: "4"},
]

Enum.each(workingTimes, fn working_time_attrs ->
  working_time_changeset = WorkingTime.changeset(%WorkingTime{}, working_time_attrs)

  case Repo.insert(working_time_changeset) do
    {:ok, workingTime} ->
      IO.puts("Created workingTimes: #{workingTime.id}")
    {:error, changeset} ->
      IO.puts("Error creating workingTimes: #{changeset.errors |> Enum.map(fn {k, v} -> "#{k}: #{elem(v, 1)}" end) |> Enum.join(", ")}")
  end
end)

################## Insert USER TEAM ##################

# priv/repo/seeds.exs

alias TimeManager.Repo
alias TimeManager.Accounts.{User, Team}

# ... le reste de votre code ...

# Fetch some users and teams by their id or other attributes
team_1 = Repo.get!(Team, 1) # replace with actual team id

# Preload the users association on the team
team_1 = Repo.preload(team_1, :users)

# Assuming you have a list of user IDs that you want to add to the team
user_ids = [2, 3, 4] # replace with actual user ids
users = Repo.all(from u in User, where: u.id in ^user_ids)

# Associate users with a team using preloaded users
team_changeset = Ecto.Changeset.change(team_1)
                 |> Ecto.Changeset.put_assoc(:users, users)

# Save the changes
case Repo.update(team_changeset) do
  {:ok, _team} ->
    IO.puts("Users have been added to the team")
  {:error, changeset} ->
    IO.puts("Error adding users to the team: #{changeset}")
end
