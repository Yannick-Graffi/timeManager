defmodule TimeManagerWeb.ClockController do
  use TimeManagerWeb, :controller

  alias TimeManager.Accounts
  alias TimeManager.Accounts.Clock

  action_fallback TimeManagerWeb.FallbackController

  # GET /clocks/:userID
  def show(conn, %{"userID" => userID}) do

    clocks = Accounts.get_clocks_by_user(userID)

    case clocks do
      [] ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Resource not found"})
      _clocks_data ->
         render(conn, :index, clocks: clocks)
    end
  end

  # POST /clocks/:userID
  def create(conn, %{"userID" => userID}) do

    if !Accounts.get_user(userID) do
      conn
      |> put_status(:not_found)
      |> json(%{error: "User not found"})
    end

    clock = Accounts.set_clock_status(userID)

    with {:ok, %Clock{} = clock} <- Accounts.create_clock(clock) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/clocks/#{userID}")
      |> render(:show, clock: clock)
    end
  end
end
