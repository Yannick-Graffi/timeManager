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
  %{username: "john_doe", email: "johna@example.com", password: "Azerty123456.", role: :employee},
  %{username: "jane_smith", email: "jane@example.com", password: "Azerty123456.", role: :employee},
  %{username: "jane_doe", email: "jane2@example.com", password: "Azerty123456.", role: :employee},
  %{username: "michael_mayne", email: "michaelmayne@example.com", password: "Azerty123456.", role: :employee},
  %{username: "emily_johnson", email: "emily.johnson@example.com", password: "Azerty123456.", role: :employee},
  %{username: "michael_davis", email: "michael.davis@example.com", password: "Azerty123456.", role: :employee},
  %{username: "jessica_taylor", email: "jessica.taylor@example.com", password: "Azerty123456.", role: :employee},
  %{username: "christopher_brown", email: "christopher.brown@example.com", password: "Azerty123456.", role: :employee},
  %{username: "amanda_wilson", email: "amanda.wilson@example.com", password: "Azerty123456.", role: :employee},
  %{username: "daniel_moore", email: "daniel.moore@example.com", password: "Azerty123456.", role: :employee},
  %{username: "sarah_anderson", email: "sarah.anderson@example.com", password: "Azerty123456.", role: :employee},
  %{username: "megan_jackson", email: "megan.jackson@example.com", password: "Azerty123456.", role: :employee},
  %{username: "kevin_white", email: "kevin.white@example.com", password: "Azerty123456.", role: :manager},
  %{username: "alice_brown", email: "alice@example.com", password: "Azerty123456.", role: :general_manager},
  %{username: "admin2", email: "admin@example.com", password: "Azerty123456.", role: :admin},
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
  %{name: "Alpha", manager_id: "14"},
  %{name: "Bravo", manager_id: "14"},
  %{name: "Charlie", manager_id: "14"},
  %{name: "Delta", manager_id: "15"},
  %{name: "Echo", manager_id: "15"},
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

tomorrow = DateTime.add(now, 1, :day)
afterTomorrow = DateTime.add(now, 2, :day)
afterThreeDays = DateTime.add(now, 3, :day)
afterFourDays = DateTime.add(now, 4, :day)

workingTimes = [
  %{start: now, end: DateTime.add(now, 3, :hour), user_id: "2"},
  %{start: now, end: DateTime.add(now, 4, :hour), user_id: "3"},
  %{start: now, end: DateTime.add(now, 6, :hour), user_id: "4"},
  %{start: now, end: DateTime.add(now, 2, :hour), user_id: "5"},
  %{start: now, end: DateTime.add(now, 3, :hour), user_id: "6"},
  %{start: now, end: DateTime.add(now, 4, :hour), user_id: "7"},
  %{start: now, end: DateTime.add(now, 3, :hour), user_id: "8"},

  %{start: DateTime.add(now, 7, :hour), end: DateTime.add(now, 11, :hour), user_id: "3"},
  %{start: DateTime.add(now, 8, :hour), end: DateTime.add(now, 9, :hour), user_id: "5"},
  %{start: DateTime.add(now, 7, :hour), end: DateTime.add(now, 10, :hour), user_id: "7"},
  %{start: DateTime.add(now, 7, :hour), end: DateTime.add(now, 10, :hour), user_id: "8"},
  %{start: DateTime.add(now, 8, :hour), end: DateTime.add(now, 12, :hour), user_id: "9"},

  %{start: tomorrow, end: DateTime.add(tomorrow, 2, :hour), user_id: "2"},
  %{start: tomorrow, end: DateTime.add(tomorrow, 3, :hour), user_id: "3"},
  %{start: tomorrow, end: DateTime.add(tomorrow, 3, :hour), user_id: "4"},
  %{start: tomorrow, end: DateTime.add(tomorrow, 4, :hour), user_id: "6"},
  %{start: tomorrow, end: DateTime.add(tomorrow, 6, :hour), user_id: "8"},
  %{start: tomorrow, end: DateTime.add(tomorrow, 4, :hour), user_id: "9"},
  %{start: tomorrow, end: DateTime.add(tomorrow, 3, :hour), user_id: "10"},
  %{start: tomorrow, end: DateTime.add(tomorrow, 2, :hour), user_id: "11"},
  %{start: tomorrow, end: DateTime.add(tomorrow, 2, :hour), user_id: "12"},

  %{start: afterTomorrow, end: DateTime.add(afterTomorrow, 3, :hour), user_id: "2"},
  %{start: afterTomorrow, end: DateTime.add(afterTomorrow, 2, :hour), user_id: "4"},
  %{start: afterTomorrow, end: DateTime.add(afterTomorrow, 5, :hour), user_id: "6"},
  %{start: afterTomorrow, end: DateTime.add(afterTomorrow, 5, :hour), user_id: "7"},
  %{start: afterTomorrow, end: DateTime.add(afterTomorrow, 4, :hour), user_id: "9"},
  %{start: afterTomorrow, end: DateTime.add(afterTomorrow, 3, :hour), user_id: "12"},
  %{start: afterTomorrow, end: DateTime.add(afterTomorrow, 5, :hour), user_id: "13"},
  %{start: afterTomorrow, end: DateTime.add(afterTomorrow, 3, :hour), user_id: "14"},

  %{start: DateTime.add(afterThreeDays, 6, :hour), end: DateTime.add(afterThreeDays, 8, :hour), user_id: "6"},
  %{start: DateTime.add(afterThreeDays, 6, :hour), end: DateTime.add(afterThreeDays, 8, :hour), user_id: "7"},
  %{start: DateTime.add(afterThreeDays, 8, :hour), end: DateTime.add(afterThreeDays, 9, :hour), user_id: "8"},
  %{start: DateTime.add(afterThreeDays, 8, :hour), end: DateTime.add(afterThreeDays, 9, :hour), user_id: "9"},
  %{start: DateTime.add(afterThreeDays, 7, :hour), end: DateTime.add(afterThreeDays, 9, :hour), user_id: "12"},
  %{start: DateTime.add(afterThreeDays, 7, :hour), end: DateTime.add(afterThreeDays, 9, :hour), user_id: "13"},
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

# Team 1

# Fetch some users and teams by their id or other attributes
team_1 = Repo.get!(Team, 1) # replace with actual team id

# Preload the users association on the team
team_1 = Repo.preload(team_1, :users)

# Assuming you have a list of user IDs that you want to add to the team
user_ids = [2, 3, 4, 5, 6, 7] # replace with actual user ids
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

# Team 2

# Fetch some users and teams by their id or other attributes
team_2 = Repo.get!(Team, 2) # replace with actual team id

# Preload the users association on the team
team_2 = Repo.preload(team_2, :users)

# Assuming you have a list of user IDs that you want to add to the team
user_ids = [8, 9, 10, 11, 12, 13] # replace with actual user ids
users = Repo.all(from u in User, where: u.id in ^user_ids)

# Associate users with a team using preloaded users
team_changeset = Ecto.Changeset.change(team_2)
                 |> Ecto.Changeset.put_assoc(:users, users)

# Save the changes
case Repo.update(team_changeset) do
  {:ok, _team} ->
    IO.puts("Users have been added to the team")
  {:error, changeset} ->
    IO.puts("Error adding users to the team: #{changeset}")
end


