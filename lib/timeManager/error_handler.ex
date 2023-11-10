defmodule TimeManager.Guardian.ErrorHandler do
  # Module responsible for handling Guardian authentication errors.

  import Plug.Conn

  # Function to handle authentication errors with an invalid token.
  def auth_error(conn, {:invalid_token, _reason}, _opts) do
    # Encodes an error message for an invalid token.
    body = Jason.encode!(%{error: "Invalid token"})
    send_resp(conn, 401, body)  # Sends a 401 status response with the error message.
  end

  # Function to handle other authentication errors.
  def auth_error(conn, {type, _reason}, _opts) do
    message = to_string(type)  # Converts the error type to a string.
    body = Jason.encode!(%{error: message})  # Encodes the error message.
    send_resp(conn, 401, body)  # Sends a 401 status response with the error message.
  end
end
