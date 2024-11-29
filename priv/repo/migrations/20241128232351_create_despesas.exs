defmodule Cfinanceiro.Repo.Migrations.CreateDespesas do
  use Ecto.Migration

  def change do
    create table(:despesas) do
      add :descricao, :string
      add :valor, :decimal
      add :data, :date

      timestamps(type: :utc_datetime)
    end
  end
end
