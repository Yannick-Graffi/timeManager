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

  # POST /clocks
  def create(conn, _params) do
    user = Guardian.Plug.current_resource(conn)

    try do
      Accounts.get_user!(user.id)
      clock = Accounts.set_clock_status(user.id)

      with {:ok, %Clock{} = clock} <- Accounts.create_clock(clock) do
        conn
        |> put_status(:created)
        |> put_resp_header("location", ~p"/api/clocks/#{user.id}")
        |> json(%{clock: clock})
      end
    rescue
      Ecto.NoResultsError -> conn
       |> put_status(:not_found)
       |> json(%{error: "User not found"})
    end
  end
end
