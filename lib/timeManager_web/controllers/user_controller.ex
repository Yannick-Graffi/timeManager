defmodule TimeManagerWeb.UserController do
  use TimeManagerWeb, :controller
  alias TimeManager.Accounts
  alias TimeManager.Accounts.User
  alias TimeManager.Repo
  alias TimeManager.Auth.Guardian

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

      user = Accounts.get_user!(id)

      case user do
        nil ->
          conn
          |> put_status(:not_found)
          |> json(%{error: "Resource not found"})
        user ->
          user_with_teams = Repo.preload(user, :teams)
          render(conn, :show_with_teams, user: user_with_teams)
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

  # GET ALL /users
  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
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
  # def update(conn, %{"id" => id, "user" => user_params}) do
  def update(conn, %{"id" => id, "user" => user_params}) do
    try do
      connectedUser = Guardian.Plug.current_resource(conn)

      # Check if ID correspond to connected user id
      if String.to_integer(id) == connectedUser.id do
        if user_params["currentPassword"] do
          case Guardian.validate_password(user_params["currentPassword"], connectedUser.password_hash) do
            false ->
              conn
              |> put_status(:unauthorized)
              |> json(%{error: "Incorrect password"})
            true ->
              with {:ok, %User{} = user} <- Accounts.update_user(id, user_params) do
                render(conn, :show, user: user)
              end
          end
#        else
#          modified_user_params = Map.put(user_params, "password", nil)
#
#          dbg(modified_user_params)
#          with {:ok, %User{} = user} <- Accounts.update_user(id, modified_user_params) do
#            render(conn, :show, user: user)
#          end
        end
      else if connectedUser.role == :manager do
             with {:ok, %User{} = user} <- Accounts.update_user(id, user_params) do
               render(conn, :show, user: user)
             end
      end
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "User doesn't match"})
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
      connectedUser = Guardian.Plug.current_resource(conn)

      dbg("--------------------")
      dbg(connectedUser.role)
      dbg("admin")
      dbg("--------------------")

      if connectedUser.role == :admin or String.to_integer(id) == connectedUser.id do
         with {:ok, %User{}} <- Accounts.delete_user(id) do
           send_resp(conn, :no_content, "")
         end
      else
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Access denied"})
      end

    rescue
      Ecto.NoResultsError -> conn
      |> put_status(:not_found)
      |> json(%{error: "Ressource not found"})
    end
  end
end
