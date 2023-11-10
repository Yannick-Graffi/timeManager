defmodule TimeManagerWeb.TeamController do
  use TimeManagerWeb, :controller

  alias TimeManager.Accounts
  alias TimeManager.Accounts.Team

  action_fallback TimeManagerWeb.FallbackController

  # GET ALL /teams
  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    case Accounts.get_teams_based_on_role(current_user) do
      {:ok, teams} ->
        updated_teams = Accounts.add_daily_working_hours(teams)
        updated_teams = Accounts.add_weekly_working_hours(updated_teams)
        updated_teams = Accounts.add_daily_and_weekly_averages(updated_teams)
        render(conn, :index, teams: updated_teams)

      {:error, :unauthorized} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Unauthorized access"})

      {:error, _reason} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: "Internal server error"})
    end
  end

  # GET ONE /teams/:id
  def show(conn, %{"id" => id}) do
    try do
      team = Accounts.get_team!(id)
      render(conn, :show, team: team)
    rescue
      Ecto.NoResultsError -> conn
      |> put_status(:not_found)
      |> json(%{error: "Resource not found"})
    end
  end

  # POST /teams
  def create(conn, %{"team" => team_params}) do
    with {:ok, %Team{} = team} <- Accounts.create_team(team_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/teams/#{team}")
      |> render(:show, team: team)
    end
  end

  # PUT /teams/:id
  def update(conn, %{"id" => id, "team" => team_params}) do
    try do
      with {:ok, %Team{} = team} <- Accounts.update_team(id, team_params) do
        render(conn, :show, team: team)
      end
    rescue
      Ecto.NoResultsError -> conn
      |> put_status(:not_found)
      |> json(%{error: "Ressource not found"})
    end
  end

  # DELETE /teams/:id
  def delete(conn, %{"id" => id}) do
    try do
      with {:ok, %Team{}} <- Accounts.delete_team(id) do
        send_resp(conn, :no_content, "")
      end
    rescue
      Ecto.NoResultsError -> conn
      |> put_status(:not_found)
      |> json(%{error: "Ressource not found"})
    end
  end
end
