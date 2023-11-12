defmodule TimeManager.Accounts.User do
  alias TimeManager.Accounts.{WorkingTime, Clock, UserRole, Team}
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :username, :email, :role, :daily, :weekly]}
  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true
    field :current_password, :string, virtual: true
    field :password_hash, :string
    field :role, UserRole, default: :employee
    has_many :clocks, Clock
    has_many :working_times, WorkingTime
    many_to_many :teams, Team, join_through: "users_teams"
    field :daily, :string, virtual: true
    field :weekly, :string, virtual: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :role])
    |> validate_required(:username, message: "Username cannot be blank.")
    |> validate_required(:email, message: "Email cannot be blank.")
    |> validate_required(:password, message: "Password cannot be blank.")
    |> validate_required(:role, message: "Role cannot be blank.")
    |> unique_constraint(:email, message: "The e-mail address is already in use")
    |> validate_format(:email, ~r/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/)
    |> validate_length(:password, min: 12, message: "Password must be at least 12 characters long.")
    |> validate_format(:password, ~r/[A-Z]/, message: "Password must contain at least one uppercase letter.")
    |> validate_format(:password, ~r/[a-z]/, message: "Password must contain at least one lowercase letter.")
    |> validate_format(:password, ~r/[^\w\s]/, message: "Password must contain at least one special character.")
    |> validate_format(:password, ~r/\d/, message: "Password must contain at least one digit.")
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
