defmodule TimeManager.ChangesetError do

  # Cette fonction prend un changeset et retourne une structure de données JSON.
  def render_errors(changeset) do
    errors = Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)

    formatted_errors = Enum.map(errors, fn {_field, messages} ->
      %{
        error: Enum.join(messages, ", ")
      }
    end)

    %{errors: formatted_errors}
  end
end
