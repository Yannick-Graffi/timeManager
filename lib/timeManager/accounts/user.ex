defmodule TimeManager.Accounts.User do
  alias TimeManager.Accounts.{WorkingTime, Clock}
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [ :username, :email]}
  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :roles, Ecto.Enum, values: [:admin, :general_manager, :manager, :employee]
    has_many :clocks, Clock
    has_many :working_times, WorkingTime
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password])
    |> validate_required(:username, message: "Username cannot be blank.")
    |> validate_required(:email, message: "Email cannot be blank.")
    |> validate_required(:password, message: "Password cannot be blank.")
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
