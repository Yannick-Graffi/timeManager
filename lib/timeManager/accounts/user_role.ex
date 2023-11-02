defmodule TimeManager.Accounts.UserRole do
  use EctoEnum, type: :user_role, enums: [:admin, :general_manager, :manager, :employee]
end