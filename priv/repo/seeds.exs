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
alias TimeManager.Accounts.{User, Team, Clock, WorkingTime, UserTeam}

################## Insert USER ##################
users = [
  %{username: "john_doe1", email: "johna@example.com", password: "azerty", role: :employee},
  %{username: "john_doe", email: "john@example.com", password: "azerty", role: :employee},
  %{username: "jane_smith", email: "jane@example.com", password: "azerty", role: :employee},
  %{username: "bob_jones", email: "bob@example.com", password: "azerty", role: :manager},
  %{username: "alice_brown", email: "alice@example.com", password: "azerty", role: :manager},
  %{username: "jane_doe", email: "jane2@example.com", password: "azerty", role: :general_manager},
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
workingTimes = [
  %{start: "2023-10-25 14:35:00", end: "2023-10-25 19:35:00", user_id: "2"},
  %{start: "2023-10-09 10:31:00", end: "2023-10-09 13:35:00", user_id: "3"},
  %{start: "2023-10-25 15:35:00", end: "2023-10-25 20:35:00", user_id: "4"},
  %{start: "2023-10-22 18:35:00", end: "2023-10-22 23:35:00", user_id: "5"},
  %{start: "2023-10-17 07:35:00", end: "2023-10-17 11:35:00", user_id: "6"},
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
userTeams = [
  %{user_id: "1", team_id: "1"},
  %{user_id: "2", team_id: "2"},
  %{user_id: "3", team_id: "3"},
  %{user_id: "4", team_id: "4"},
  %{user_id: "5", team_id: "5"},
]

Enum.each(userTeams, fn user_team_attrs ->
  user_team_changeset = UserTeam.changeset(%UserTeam{}, user_team_attrs)

  case Repo.insert(user_team_changeset) do
    {:ok, userTeam} ->
      IO.puts("Created user team")
    {:error, changeset} ->
      IO.puts("Error creating user team: #{changeset.errors |> Enum.map(fn {k, v} -> "#{k}: #{elem(v, 1)}" end) |> Enum.join(", ")}")
  end
end)
