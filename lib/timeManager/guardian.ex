defmodule TimeManager.Guardian do
  use Guardian, otp_app: :timeManager

  def subject_for_token(resource, _claims) do
    # Ici, vous retournez la clé unique identifiant l'utilisateur, par exemple l'ID de l'utilisateur.
    sub = to_string(resource.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    # Ici, vous trouvez l'utilisateur en fonction du `sub` qui a été codé dans le token.
    id = claims["sub"]
    resource = TimeManager.Accounts.get_user(id)
    {:ok, resource}
  end
end
