defmodule TimeManager.Plugs.AccessToken do
  import Plug.Conn

  def init(options), do: options

  def call(conn, _options) do
    conn
    |> get_access_token_from_cookie()
    |> verify_access_token()
  end

  defp get_access_token_from_cookie(conn) do
    cookies = conn.cookies()
    token = cookies["guardian_default_token"]

    if token do
      assign(conn, :guardian_token, token)
    else
      conn
    end
  end

  defp verify_access_token(conn) do
    case conn.assigns[:guardian_token] do
      nil ->
        # Si le token n'est pas trouvé, renvoyer un statut d'erreur
        conn
        |> send_resp(401, "Authentication failed")
        |> halt()

      token ->
        # Vérifier la validité du token
        case Guardian.decode_and_verify(TimeManager.Auth.Guardian, token) do
          {:ok, claims} ->
            # Le token est valide, vous pouvez continuer avec le traitement de la requête
            # et éventuellement assigner l'utilisateur à la connexion, si nécessaire.
            assign(conn, :claims, claims)

          {:error, reason} ->
            # Le token n'est pas valide, logger la raison et renvoyer un statut d'erreur
            dbg(reason)
            conn
            |> send_resp(401, "Authentication failed")
            |> halt()
        end
    end
  end

end
