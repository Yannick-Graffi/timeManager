defmodule TimeManager.Accounts.Clock do
  use Ecto.Schema
  import Ecto.Changeset
  alias TimeManager.Accounts.User

  schema "clocks" do
    field :status, :boolean, default: false
    field :time, :utc_datetime
    belongs_to :users, User
  end

  @doc false
  def changeset(clock, attrs) do
    clock
    |> cast(attrs, [:time, :status, :users_id])
    |> validate_required([:time, :status])
  end
end
