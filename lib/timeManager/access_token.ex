defmodule TimeManager.Plugs.AccessToken do
  import Plug.Conn

  # Initializes the plug with options, but no initialization is needed in this case
  def init(options), do: options

  # Main function of the plug, checks and manages authentication using an access token
  def call(conn, _options) do
    conn
    |> get_access_token_from_cookie()  # Retrieve the access token from cookies
    |> verify_access_token()           # Verify the validity of the access token
  end

  # Private function to retrieve the access token from cookies
  defp get_access_token_from_cookie(conn) do
    cookies = conn.cookies()
    token = cookies["guardian_default_token"]

    if token do
      assign(conn, :guardian_token, token)  # Assigns the access token to the connection
    else
      conn  # Returns the connection unchanged if no token is found
    end
  end

  # Private function to verify the validity of the access token
  defp verify_access_token(conn) do
    case conn.assigns[:guardian_token] do
      nil ->
        # If token is not found, send an error status
        conn
        |> send_resp(401, "Authentication failed")
        |> halt()

      token ->
        # Check the validity of the token
        case Guardian.decode_and_verify(TimeManager.Auth.Guardian, token) do
          {:ok, claims} ->
            # Token is valid, you can proceed with request processing
            # and potentially assign claims to the connection, if needed.
            assign(conn, :claims, claims)

          {:error, reason} ->
            # Token is not valid, log the reason and send an error status
            dbg(reason)  # Logs the error reason (for debugging purposes)
            conn
            |> send_resp(401, "Authentication failed")
            |> halt()
        end
    end
  end
end
