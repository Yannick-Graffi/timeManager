defmodule TimeManager.Guardian.Pipeline do
  use Guardian.Plug.Pipeline, otp_app: :timeManager,
                              module: TimeManager.Auth.Guardian,
                              error_handler: TimeManager.Guardian.ErrorHandler

  plug Guardian.Plug.VerifyHeader, scheme: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
