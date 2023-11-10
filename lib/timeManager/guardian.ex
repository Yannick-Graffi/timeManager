defmodule TimeManager.Auth.Guardian do
  # Module responsible for handling authentication using Guardian.

  use Guardian, otp_app: :timeManager
  alias TimeManager.Accounts

  # Function to extract the subject for the token based on user id.
  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  # Function to handle cases where no ID is provided for the token subject.
  def subject_for_token(_, _) do
    {:error, :no_id_provided}
  end

  # Function to fetch the user resource from the claims in the token.
  def resource_from_claims(%{"sub" => id}) do
    case Accounts.get_user!(id) do
      nil -> {:error, :not_found}
      resource -> {:ok, resource}
    end
  end

  # Function to handle cases where no ID is provided in the claims.
  def resource_from_claims(_claims) do
    {:error, :no_id_provided}
  end

  # Function to authenticate a user based on email and password.
  def authenticate(email, password) do
    case Accounts.get_user_by_email(email) do
      nil -> {:error, :unauthorized}
      user ->
        case validate_password(password, user.password_hash) do
          true -> create_token(user)
          false -> {:error, :unauthorized}
        end
    end
  end

  # Function to validate a password by checking it against its hashed value.
  def validate_password(password, hash_password) do
    Bcrypt.verify_pass(password, hash_password)
  end

  # Function to create a token after successful user authentication.
  defp create_token(user) do
    {:ok, token, _claims} = encode_and_sign(user)
    {:ok, user, token}
  end

  # Function to perform actions after encoding and signing the token.
  def after_encode_and_sign(resource, claims, token, _options) do
    with {:ok, _} <- Guardian.DB.after_encode_and_sign(resource, claims["typ"], claims, token) do
      {:ok, token}
    end
  end

  # Function to handle actions during the token verification process.
  def on_verify(claims, token, _options) do
    with {:ok, _} <- Guardian.DB.on_verify(claims, token) do
      {:ok, claims}
    end
  end

  # Function to manage actions during the token refresh process.
  def on_refresh({old_token, old_claims}, {new_token, new_claims}, _options) do
    with {:ok, _, _} <- Guardian.DB.on_refresh({old_token, old_claims}, {new_token, new_claims}) do
      {:ok, {old_token, old_claims}, {new_token, new_claims}}
    end
  end

  # Function to handle actions during token revocation.
  def on_revoke(claims, token, _options) do
    with {:ok, _} <- Guardian.DB.on_revoke(claims, token) do
      {:ok, claims}
    end
  end
end
