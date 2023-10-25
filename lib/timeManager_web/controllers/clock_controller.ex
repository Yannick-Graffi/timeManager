defmodule TimeManagerWeb.ClockController do
  use TimeManagerWeb, :controller

  import Ecto.Query

  alias TimeManager.Accounts
  alias TimeManager.Accounts.Clock
  alias TimeManager.Repo

  action_fallback TimeManagerWeb.FallbackController

  def create(conn, %{"clock" => clock_params}) do
    with {:ok, %Clock{} = clock} <- Accounts.create_clock(clock_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/clocks/#{clock}")
      |> render(:show, clock: clock)
    end
  end

  def show(conn, %{"userID" => userID}) do
    query = from c in Clock,
                         where: c.users_id == ^userID
    clocks = Repo.all(query)
    render(conn, :index, clocks: clocks)
  end
end
