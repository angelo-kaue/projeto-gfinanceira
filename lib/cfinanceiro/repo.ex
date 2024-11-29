defmodule Cfinanceiro.Repo do
  use Ecto.Repo,
    otp_app: :cfinanceiro,
    adapter: Ecto.Adapters.Postgres
end
