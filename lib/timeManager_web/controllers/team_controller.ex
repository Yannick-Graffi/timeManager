defmodule TimeManagerWeb.TeamController do
  use TimeManagerWeb, :controller

  alias TimeManager.Accounts
  alias TimeManager.Accounts.Team

  action_fallback TimeManagerWeb.FallbackController

  # GET ALL /teams
  def index(conn, _params) do
      teams = Accounts.list_team()
      render(conn, :index, teams: teams)
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
