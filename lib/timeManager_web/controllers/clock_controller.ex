defmodule TimeManagerWeb.ClockController do
  use TimeManagerWeb, :controller

  import Ecto.Query

  alias TimeManager.Accounts
  alias TimeManager.Accounts.Clock
  alias TimeManager.Repo

  action_fallback TimeManagerWeb.FallbackController

  # POST /api/clocks/:userID
  def create(conn, %{"userID" => userID}) do

    if !Accounts.get_user(userID) do
      conn
      |> put_status(:not_found)
      |> json(%{error: "User not found"})
    end

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

    with {:ok, %Clock{} = clock} <- Accounts.create_clock(clock) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/clocks/#{userID}")
      |> render(:show, clock: clock)
    end
  end

  # GET /api/clocks/:userID
  def show(conn, %{"userID" => userID}) do
    query = from c in Clock,
                         where: c.user_id == ^userID
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
