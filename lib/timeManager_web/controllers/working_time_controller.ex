defmodule TimeManagerWeb.WorkingTimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.Accounts
  alias TimeManager.Accounts.WorkingTime


  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    working_times = Accounts.list_working_times()
    render(conn, :index, working_times: working_times)
  end

  def create(conn, %{"working_time" => working_time_params}) do
    with {:ok, %WorkingTime{} = working_time} <- Accounts.create_working_time(working_time_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/workingTimes/:userID")
      |> render(:show, working_time: working_time)
    end
  end


  def show(conn, %{"id" => id}) do

    try do
      working_time = Accounts.get_working_time!(id)
      render(conn, :show, working_time: working_time)
    rescue
      Ecto.NoResultsError -> conn
                                |> put_status(:bad_request)
                                |> json(%{error: "please enter valid fields"})

    end
  end


  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = Accounts.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <- Accounts.update_working_time(working_time, working_time_params) do
      render(conn, :show, working_time: working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = Accounts.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- Accounts.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end
