defmodule TimeManager.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo
  alias TimeManager.Accounts.{User, Team}

  ############### User ################

  @doc """
  Gets a single user.any()

  Returns 'nil' if the User does not exist.

  ## Examples

    iex> get_user_by_email(test@email.com)
    %Account{}

    iex> get_user_by_email(no_account@email.com)
    nil
  """
  def get_user_by_email(email) do
    User
    |> where(email: ^email)
    |> Repo.one()
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets a single user.

  Raises nil if the User does not exist.

  ## Examples

      iex> get_user(123)
      %User{}

      iex> get_user(456)
      ** nil
  """
  def get_user(id), do: Repo.get(User, id)

  @doc """
  Gets a single user.

  Raises nil if the User does not exist.

  ## Examples

      iex> get_user(123)
      %User{}

      iex> get_user(456)
      ** nil
  """
  def get_user_teams(id) do
    query = from u in User,
                 where: u.id == ^id,
                 preload: [:teams]
    user_with_teams = Repo.one(query)

    dbg(user_with_teams)
  end

  @doc """
  Get a single user by email and username.

  Raises `Ecto.NoResultsError` if the User does not exist.

   ## Examples

      iex> get_user_by_email_and_username(123)
      %User{}

      iex> get_user_by_email_and_username(456)
      ** (Ecto.NoResultsError)
  """
  def get_user_by_email_and_username(email, username), do:
  Repo.get_by!(User, email: email, username: username)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(id, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(id, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(id, attrs) do
    user = get_user!(id)
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(id)
      {:ok, %User{}}

      iex> delete_user(id)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(id) do
    user = get_user!(id)
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  ############### Clock ################
  alias TimeManager.Accounts.Clock

  @doc """
  Returns the list of clocks.

  ## Examples

      iex> list_clocks()
      [%Clock{}, ...]

  """
  def list_clocks do
    Repo.all(Clock)
  end

  @doc """
  Gets a single clock.

  Raises `Ecto.NoResultsError` if the Clock does not exist.

  ## Examples

      iex> get_clock!(123)
      %Clock{}

      iex> get_clock!(456)
      ** (Ecto.NoResultsError)

  """
  def get_clock!(id), do: Repo.get!(Clock, id)

  @doc """
    Gets clocks by user.

    Return list of clocks found by user.
  """
  def get_clocks_by_user(userID) do
    query = from c in Clock,
      where: c.user_id == ^userID

      clocks = Repo.all(query)
      clocks
  end

  @doc """
  Creates a clock.

  ## Examples

      iex> create_clock(%{field: value})
      {:ok, %Clock{}}

      iex> create_clock(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_clock(attrs \\ %{}) do
    %Clock{}
    |> Clock.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a clock.

  ## Examples

      iex> update_clock(id, %{field: new_value})
      {:ok, %Clock{}}

      iex> update_clock(id, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_clock(id, attrs) do
    clock = get_clock!(id)
    clock
    |> Clock.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a clock.

  ## Examples

      iex> delete_clock(id)
      {:ok, %Clock{}}

      iex> delete_clock(id)
      {:error, %Ecto.Changeset{}}

  """
  def delete_clock(id) do
    clock = get_clock!(id)
    Repo.delete(clock)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking clock changes.

  ## Examples

      iex> change_clock(clock)
      %Ecto.Changeset{data: %Clock{}}

  """
  def change_clock(%Clock{} = clock, attrs \\ %{}) do
    Clock.changeset(clock, attrs)
  end

  @doc """
    Set and return clock.

    Set new clock body.
    Get most recent clock by user.
    Set clock status depending on most recent clock found previously

    ## Examples

      iex> set_clock_status(123)
      %Clock{}
  """
  def set_clock_status(userID) do
    clock = %{status: true, time: DateTime.truncate(DateTime.utc_now(), :second), user_id: userID}

    query = from c in Clock,
                 where: c.user_id == ^userID,
                 order_by: [desc: c.time],
                 limit: 1
    most_recent_clock = Repo.one(query)

    clock =
      if most_recent_clock do
        new_clock = %{clock | status: !most_recent_clock.status}
        new_clock
      else
        clock
      end
    clock
  end

  ############### WorkingTime ################
  alias TimeManager.Accounts.WorkingTime

  @doc """
  Returns the list of working_times.

  ## Examples

      iex> list_working_times()
      [%WorkingTime{}, ...]

  """
  def list_working_times do
    Repo.all(WorkingTime)
  end

  @doc """
  Gets a single working_time.

  Raises `Ecto.NoResultsError` if the Working time does not exist.

  ## Examples

      iex> get_working_time!(123)
      %WorkingTime{}

      iex> get_working_time!(456)
      ** (Ecto.NoResultsError)

  """
  def get_working_time!(id), do: Repo.get!(WorkingTime, id)

  @doc """
  Gets all working_times by start, end and user.

  Set a query request with condition for get only working times
    between the dates (start, end) and with the userID associated.
  Return a list of working times

  ## Examples

    iex> get_working_time!(123)
    %WorkingTime{}

    iex> get_working_time!(456)
    ** (Ecto.NoResultsError)
  """
  def get_working_time_by_start_end_user(startDate, endDate, userID) do
    query = from w in WorkingTime,
       where: w.start >= ^startDate,
       where: w.end <= ^endDate,
       where: w.user_id == ^userID

    Repo.all(query)
  end

  @doc """
  Gets one working time by id and user.

  Find working time by user associated and by id of working time

  """
  def get_working_time_by_id_and_user(id, userID) do
    Repo.get_by!(WorkingTime, id: id, user_id: userID)
  end

  @doc """
  Creates a working_time.

  ## Examples

      iex> create_working_time(%{field: value})
      {:ok, %WorkingTime{}}

      iex> create_working_time(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_working_time(attrs \\ %{}) do
    %WorkingTime{}
    |> WorkingTime.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a working_time.

  ## Examples

      iex> update_working_time(id, %{field: new_value})
      {:ok, %WorkingTime{}}

      iex> update_working_time(id, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_working_time(id, attrs) do
    working_time = get_working_time!(id)
    working_time
    |> WorkingTime.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a working_time.

  ## Examples

      iex> delete_working_time(id)
      {:ok, %WorkingTime{}}

      iex> delete_working_time(id)
      {:error, %Ecto.Changeset{}}

  """
  def delete_working_time(id) do
    working_time = get_working_time!(id)
    Repo.delete(working_time)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking working_time changes.

  ## Examples

      iex> change_working_time(working_time)
      %Ecto.Changeset{data: %WorkingTime{}}

  """
  def change_working_time(%WorkingTime{} = working_time, attrs \\ %{}) do
    WorkingTime.changeset(working_time, attrs)
  end

  ############### Team ################
  alias TimeManager.Accounts.Team

  @doc """
  Returns the list of teams.

  ## Examples

      iex> list_team()
      [%Team{}, ...]

  """
  def list_team do
    Repo.all(Team)
  end

  @doc """
  Gets a single team.

  Raises `Ecto.NoResultsError` if the Team does not exist.

  ## Examples

      iex> get_team!(123)
      %User{}

      iex> get_team!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team!(id), do: Repo.get!(Team, id)

  def get_teams_based_on_role(%User{} = current_user) do
    case current_user.role do
      :admin ->
        {:ok, Repo.all(Team)}

      :general_manager ->
        {:ok, Repo.all(Team)}

      :manager ->
        # Récupérer toutes les équipes gérées par le manager courant
        teams = Repo.all(
          from t in Team,
          where: t.manager_id == ^current_user.id,
          preload: [users: :teams]
        )
        {:ok, teams}

      _ ->
        {:error, :unauthorized}
    end
  end

  @doc """
  Creates a team.

  ## Examples

      iex> create_team(%{field: value})
      {:ok, %Team{}}

      iex> create_team(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a team.

  ## Examples

      iex> update_team(id, %{field: new_value})
      {:ok, %Team{}}

      iex> update_team(id, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team(id, attrs) do
    team = get_team!(id)
    team
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a team.

  ## Examples

      iex> delete_team(id)
      {:ok, %Team{}}

      iex> delete_team(id)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team(id) do
    team = get_team!(id)
    Repo.delete(team)
  end
end
