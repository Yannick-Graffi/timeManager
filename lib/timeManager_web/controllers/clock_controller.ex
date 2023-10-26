defmodule TimeManagerWeb.ClockController do
  use TimeManagerWeb, :controller

  import Ecto.Query

  alias TimeManager.Accounts
  alias TimeManager.Accounts.{Clock, User}
  alias TimeManager.Repo

  action_fallback TimeManagerWeb.FallbackController

  def create(conn, %{"userID" => userID}) do
    %User{} = user = Accounts.get_user!(userID)

    query = from c in Clock,
                 where: c.users_id == ^userID,
                 order_by: [desc: c.time],
                 limit: 1
    most_recent_clock = Repo.one(query)

    with {:ok, %Clock{} = clock} <- Accounts.create_clock(%{status: !most_recent_clock.status, time: DateTime.truncate(DateTime.utc_now(), :second), users_id: userID}) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/clocks/#{userID}")
      |> render(:show, clock: clock)
    end
  end

  def show(conn, %{"userID" => userID}) do
    query = from c in Clock,
                         where: c.users_id == ^userID
    clocks = Repo.all(query)

    case clocks do
      [] ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Ressource not found"})
      clocks_data ->
        render(conn, :index, clocks: clocks_data)
    end
  end
end
