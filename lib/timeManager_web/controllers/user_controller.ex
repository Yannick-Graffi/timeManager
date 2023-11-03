defmodule TimeManagerWeb.UserController do
  use TimeManagerWeb, :controller

  alias TimeManager.Accounts
  alias TimeManager.Accounts.User

  action_fallback TimeManagerWeb.FallbackController

  def me(conn, _params) do
    try do
      user = Guardian.Plug.current_resource(conn)
      render(conn, :show, user: user)
    rescue
      Ecto.NoResultsError -> conn
                             |> put_status(:not_found)
                             |> json(%{error: "Resource not found"})
    end
  end

  # GET ONE /users/:id
  def show(conn, %{"id" => id}) do
    try do
      user = Accounts.get_user!(id)
      render(conn, :show, user: user)
    rescue
      Ecto.NoResultsError -> conn
      |> put_status(:not_found)
      |> json(%{error: "Resource not found"})
    end
  end

  # GET ONE /users?email=&username=
  def index(conn, %{"email" => email, "username" => username}) do

    try do
      user = Accounts.get_user_by_email_and_username(email, username)
      render(conn, :show, user: user)
    rescue
      Ecto.NoResultsError -> conn
       |> put_status(:not_found)
       |> json(%{error: "Resource not found"})
    end
  end

  # GET ONE /users
  def index(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: "Email and username parameters are required"})
  end

  # POST /users
  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  # PUT /users/:id
  def update(conn, %{"id" => id, "user" => user_params}) do
    try do
      with {:ok, %User{} = user} <- Accounts.update_user(id, user_params) do
        render(conn, :show, user: user)
      end
    rescue
      Ecto.NoResultsError -> conn
      |> put_status(:not_found)
      |> json(%{error: "Ressource not found"})
    end
  end

  # DELETE /users/:id
  def delete(conn, %{"id" => id}) do
    try do
      user = Accounts.get_user!(id)

      with {:ok, %User{}} <- Accounts.delete_user(user) do
        send_resp(conn, :no_content, "")
      end
    rescue
      Ecto.NoResultsError -> conn
      |> put_status(:not_found)
      |> json(%{error: "Ressource not found"})
    end
  end
end
