defmodule TimeManagerWeb.WorkingTimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.Accounts
  alias TimeManager.Accounts.WorkingTime

  action_fallback TimeManagerWeb.FallbackController

  # GET ALL /workingTimes/:userID?start=&end=
  def index(conn, %{"start" => paramsStart, "end" => paramsEnd, "userID" => userID}) do
    try do
      Accounts.get_user!(userID)
      working_times = Accounts.get_working_time_by_start_end_user(paramsStart, paramsEnd, userID)

      render(conn, :index, working_times: working_times)
    rescue
      Ecto.Query.CastError -> conn
      |> put_status(:bad_request)
      |> json(%{error: "Invalid date format"})

      Ecto.NoResultsError -> conn
      |> put_status(:not_found)
      |> json(%{error: "User not found"})
    end
  end

  # GET ALL /workingTimes/:id
  def index(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: "Parameters start and end are required"})
  end

  def today(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    date_today = Date.utc_today()
    time_midnight = Time.new!(0, 0, 0, 0)
    {:ok, midnight_today} = DateTime.new(date_today, time_midnight)
    date_tomorrow = Date.add(date_today, 1)
    {:ok, midnight_tomorrow} = DateTime.new(date_tomorrow, time_midnight)
    working_times = Accounts.get_working_time_by_start_end_user(midnight_today, midnight_tomorrow, user.id)
    render(conn, :index, working_times: working_times)
  end

  # GET ONE /workingTimes/:userID/:id
  def show(conn, %{"userID" => userID, "id" => id}) do
    try do
      working_time = Accounts.get_working_time_by_id_and_user(id, userID)
      render(conn, :show, working_time: working_time)
    rescue
      Ecto.NoResultsError -> conn
      |> put_status(:not_found)
      |> json(%{error: "Resource or user not found"})
    end
  end

  # POST /workingTimes
  def create(conn, %{"working_time" => working_time_params, "userID" => userID}) do
    working_time_params_with_user_id = Map.put(working_time_params, "user_id", userID)
    try do
      with {:ok, _working_time} <- Accounts.create_working_time(working_time_params_with_user_id) do
        conn
        |> put_status(:created)
        |> json(%{message: "Working Time created successfully."})
      end
    rescue
      Ecto.ConstraintError -> conn
      |> put_status(:bad_request)
      |> json(%{error: "User not found"})
    end
  end

  # PUT /workingTimes/:id
  def update(conn, %{"id" => id, "working_time" => working_time_params}) do

    try do
      with {:ok, %WorkingTime{} = working_time} <- Accounts.update_working_time(id, working_time_params) do
        render(conn, :show, working_time: working_time)
      end
    rescue
      Ecto.NoResultsError -> conn
      |> put_status(:not_found)
      |> json(%{error: "Resource not found"})

      Ecto.ConstraintError -> conn
      |> put_status(:bad_request)
      |> json(%{error: "User not found"})
    end
  end

  # DELETE /workingTimes/:id
  def delete(conn, %{"id" => id}) do
    try do
      with {:ok, %WorkingTime{}} <- Accounts.delete_working_time(id) do
        send_resp(conn, :no_content, "")
      end
    rescue
      Ecto.NoResultsError -> conn
      |> put_status(:not_found)
      |> json(%{error: "Resource not found"})
    end
  end
end
