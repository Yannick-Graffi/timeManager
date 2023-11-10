defmodule TimeManager.Guardian.Pipeline do
  # Define the module for the Guardian pipeline in the TimeManager namespace
  use Guardian.Plug.Pipeline, otp_app: :timeManager,
                              module: TimeManager.Auth.Guardian,
                              error_handler: TimeManager.Guardian.ErrorHandler

  # Include the Guardian plug to verify the header using the "Bearer" scheme
  plug Guardian.Plug.VerifyHeader, scheme: "Bearer"

  # Ensure authentication by using Guardian's authentication plug
  plug Guardian.Plug.EnsureAuthenticated

  # Load the necessary resource using Guardian's resource loading plug
  plug Guardian.Plug.LoadResource
end
