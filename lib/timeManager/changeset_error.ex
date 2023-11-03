defmodule TimeManager.ChangesetError do
  # Cette fonction prend un changeset et retourne une erreur sous la forme spécifiée.
  def render_errors(changeset) do
    errors = Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)

    # Trouve la première erreur et la formate.
    formatted_error = errors
                      |> Enum.map(fn {_field, messages} -> Enum.join(messages, ", ") end)
                      |> List.first()

    # Retourne uniquement la première erreur trouvée, ou une erreur par défaut si aucune n'est trouvée.
    %{
      error: formatted_error || "Une erreur inattendue est survenue."
    }
  end
end
