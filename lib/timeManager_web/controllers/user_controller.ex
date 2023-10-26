defmodule TimeManagerWeb.UserController do
  use TimeManagerWeb, :controller

  alias TimeManager.Accounts
  alias TimeManager.Accounts.User
  alias TimeManager.Repo

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, %{"email" => email, "username" => username}) do

    try do
      user = Repo.get_by!(User, email: email, username: username)
      render(conn, :show, user: user)
    rescue
      Ecto.NoResultsError -> conn
                                  |> put_status(:bad_request)
                                  |> json(%{error: "email or username are invalid"})
    end
  end

  def index(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: "email and username parameters are required"})
  end


  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    try do
      user = Accounts.get_user!(id)
      render(conn, :show, user: user)
    rescue
      Ecto.NoResultsError -> conn
                                  |> put_status(:bad_request)
                                  |> json(%{error: "Ressource not found"})
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    try do
      user = Accounts.get_user!(id)
      with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
        render(conn, :show, user: user)
      end
    rescue
      Ecto.NoResultsError -> conn
                                  |> put_status(:bad_request)
                                  |> json(%{error: "Ressource not found"})
    end
  end

  def delete(conn, %{"id" => id}) do
    try do
      user = Accounts.get_user!(id)

      with {:ok, %User{}} <- Accounts.delete_user(user) do
        send_resp(conn, :no_content, "")
      end
    rescue
      Ecto.NoResultsError -> conn
                                  |> put_status(:bad_request)
                                  |> json(%{error: "Ressource not found"})
    end
  end
end
