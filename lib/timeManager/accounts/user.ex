defmodule TimeManager.Accounts.User do
  alias TimeManager.Accounts.{WorkingTime, Clock}
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    has_many :clocks, Clock
    has_many :working_times, WorkingTime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password])
    |> validate_required([:username, :email, :password])
    |> unique_constraint(:email, message: "The e-mail address is already in use")
    |> validate_format(:email, ~r/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/)
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    password = get_field(changeset, :password)
    case password do
      nil -> changeset
      _ -> put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))
    end
  end
end
