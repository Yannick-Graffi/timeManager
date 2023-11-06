defmodule TimeManager.Accounts.Clock do
  use Ecto.Schema
  import Ecto.Changeset
  alias TimeManager.Accounts.User

  @derive {Jason.Encoder, only: [:status, :time]}
  schema "clocks" do
    field :status, :boolean, default: false
    field :time, :utc_datetime
    belongs_to :user, User
  end

  @doc false
  def changeset(clock, attrs) do
    clock
    |> cast(attrs, [:time, :status, :user_id])
    |> validate_required([:time, :status])
  end
end
