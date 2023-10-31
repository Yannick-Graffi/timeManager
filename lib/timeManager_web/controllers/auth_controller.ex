defmodule TimeManagerWeb.AuthController do
  use TimeManagerWeb, :controller
  alias TimeManager.Accounts

  # Endpoint pour se connecter
  def login(conn, %{"email" => email, "password" => password}) do
    case Accounts.authenticate(email, password) do
      {:ok, user} ->
        # Ici, vous devriez générer et envoyer un token JWT ou similaire
        token = Accounts.generate_token(user)
        json(conn, %{token: token})
      :error ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid credentials"})
    end
  end

  # Endpoint pour se déconnecter
  def logout(conn, _params) do
    # Ici, vous devriez invalider le token JWT ou similaire
    # Par exemple, en le supprimant de la base de données si vous le stockez,
    # ou en ajoutant son jti à une liste noire si vous utilisez JWT avec jti.
    json(conn, %{message: "Logged out"})
  end
end
