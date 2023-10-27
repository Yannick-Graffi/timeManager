defmodule TimeManagerWeb.WorkingTimeController do
  use TimeManagerWeb, :controller

  import Ecto.Query

  alias TimeManager.Accounts
  alias TimeManager.Accounts.WorkingTime
  alias TimeManager.Repo

  action_fallback TimeManagerWeb.FallbackController

  # GET ALL /workingTimes/:userID?start=&end=
  def index(conn, %{"start" => paramsStart, "end" => paramsEnd, "userID" => userID}) do

    try do
      query = from w in WorkingTime,
        where: w.start >= ^paramsStart,
        where: w.end <= ^paramsEnd,
        where: w.user_id == ^userID

      working_times = Repo.all(query)
      render(conn, :index, working_times: working_times)
    rescue
      Ecto.Query.CastError -> conn
      |> put_status(:bad_request)
      |> json(%{error: "Invalid user id or invalid date format"})
    end
  end

  # GET ALL /workingTimes/:id
  def index(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: "start and end parameters are required"})

    # working_times = Accounts.list_working_times()
    # render(conn, :index, working_times: working_times)
  end

  # GET ONE /workingTimes/:userID/:id
  def show(conn, %{"userID" => userID, "id" => id}) do

    working_time = Repo.get_by(WorkingTime, id: id, user_id: userID)
    case working_time do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Ressource not found"})
      _ ->
        render(conn, :show, working_time: working_time)
    end
  end

  # POST /workingTimes
  def create(conn, %{"working_time" => working_time_params, "userID" => userID}) do
    working_time_params_with_user_id = Map.put(working_time_params, "user_id", userID)
    
    with {:ok, %WorkingTime{} = working_time} <- Accounts.create_working_time(working_time_params_with_user_id) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/workingTimes/:userID")
      |> render(:show, working_time: working_time)
    end
  end

  # PUT /workingTimes/:id
  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = Accounts.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <- Accounts.update_working_time(working_time, working_time_params) do
      render(conn, :show, working_time: working_time)
    end
  end

  # DELETE /workingTimes/:id
  def delete(conn, %{"id" => id}) do
    working_time = Accounts.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- Accounts.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end
