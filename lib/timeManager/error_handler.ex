defmodule TimeManager.Guardian.ErrorHandler do
  import Plug.Conn

  def auth_error(conn, {:invalid_token, _reason}, _opts) do
    body = Jason.encode!(%{error: "Invalid token"})
    send_resp(conn, 401, body)
  end
  def auth_error(conn, {type, _reason}, _opts) do
    message = to_string(type)
    body = Jason.encode!(%{error: message})
    send_resp(conn, 401, body)
  end

end
