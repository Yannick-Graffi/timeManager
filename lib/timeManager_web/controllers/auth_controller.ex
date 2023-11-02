defmodule TimeManagerWeb.AuthController do
  use TimeManagerWeb, :controller
  alias TimeManager.{Accounts, Accounts.User}
  alias TimeManager.Auth.Guardian

  # Endpoint pour se connecter
  def login(conn, %{"email" => email, "password" => password}) do
    case TimeManager.Auth.Guardian.authenticate(email, password) do
      {:ok, user, token} ->
        json(conn, %{token: token, user: user})
      {:error, :unauthorized} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid credentials"})
    end
  end


  def create(conn, %{"user" => user_params}) do
    with {:ok, _user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:ok)
      |> json(%{message: "Successful registration."})
    else
      {:error, changeset} ->
        conn
        |> put_status(:unauthorized)
        |> json(TimeManager.ChangesetError.render_errors(changeset))
    end
  end


  # Endpoint pour se déconnecter
  def logout(conn, _params) do
    # Récupérez le claims et le token à partir de la connexion
    token = TimeManager.Auth.Guardian.Plug.current_token(conn)
    with {:ok, _claims} <- TimeManager.Auth.Guardian.revoke(token) do
      json(conn, %{message: "Logged out successfully."})
    else
      {:error, reason} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Unable to revoke token: #{reason}"})
    end
  end
end
