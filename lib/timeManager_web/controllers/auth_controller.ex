defmodule TimeManagerWeb.AuthController do
  use TimeManagerWeb, :controller
  alias TimeManager.Accounts
  alias TimeManager.Auth.Guardian

  # Endpoint pour se connecter
  def login(conn, %{"email" => email, "password" => password}) do
    case Guardian.authenticate(email, password) do
      {:ok, user, token} ->
        #json(conn, %{token: token, user: user, message: "Login successfully"})
        #{:ok, _old, {new_token, _new_claims}} = Guardian.refresh(token)
        #dbg(new_token)
        #conn
        #|> put_resp_cookie("guardian_default_token", token, http_only: true)
        #|> json(%{ user: user})
        json(conn, %{token: token, user: user, message: "Login successfully"})
      {:error, :unauthorized} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{ error: "Invalid credentials" })
    end
  end


  def create(conn, %{"email" => email, "password" => password, "username" => username}) do
    with {:ok, _user} <- Accounts.create_user(%{"email" => email, "password" => password, "username" => username}) do
      conn
      |> put_status(:ok)
      |> json(%{message: "Successful registration."})
    else
      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(TimeManager.ChangesetError.render_errors(changeset))
    end
  end


  # Endpoint pour se déconnecter
  def logout(conn, _params) do
    # Récupérez le claims et le token à partir de la connexion
    token = Guardian.Plug.current_token(conn)
    with {:ok, _claims} <- Guardian.revoke(token) do
      json(conn, %{message: "Logged out successfully."})
    else
      {:error, reason} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Unable to revoke token: #{reason}"})
    end
  end
end
